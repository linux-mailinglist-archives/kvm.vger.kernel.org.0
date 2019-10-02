Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EDDC92C6
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJBUKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 16:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfJBUKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 16:10:23 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30ADC5945B
        for <kvm@vger.kernel.org>; Wed,  2 Oct 2019 20:10:23 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id w10so45085wrl.5
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 13:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ECzmcjCSbbcsFSzX1mjy2hRL/7INCALmJsVRlbIqA+M=;
        b=BCDrjYY+PB7MaRtomR66swUo312Csh7XA6SZ6musdpyiqf+gL58eNEoMRxx2Kte1vM
         pA+Xa4xx709wcuaIAiqXaHTK6nA1lvucWVwhunsXmyJ0oH50n/wv96LVoaETIxo8ylca
         0DjD/SBObn1HXXC2hYjbqrBTb/wvTSfQgF9p+eIulaI5S25p2jM7bBwLp7ojJAa8AFdV
         gxMrPbRmOdp72XcjiantduvyJcMw++Kt3l+sJ6jnI59oW8b4dfa7KJDxh1eADPgqjz2K
         r2UtWJlVKkxUzX4DPhOHRzwDk0MZB3nFkk31jYYQ/VsRz2QsJGI1B8y4erDrmjkNv/cS
         MQ5g==
X-Gm-Message-State: APjAAAUVPEobcNS4xdfO6cjL0P6EfCm3EGYpq+Z+ikD8J9O41qtMGFsU
        69Dervn2PploO1XYOzjjncr+pcbvxQj+uCWts0ZyNrQtrRjASfF6t/4aJPHwR7TEJHqOHzXpysn
        AqUTsH82vAPU5
X-Received: by 2002:a5d:5185:: with SMTP id k5mr4309021wrv.341.1570047021834;
        Wed, 02 Oct 2019 13:10:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwCrWt+T8lq0j3jrbvKKSdlpqYZ0reHvLDTlwAHJf9pBgzMN4snDZo/L2kojw/X0EwObK+tMQ==
X-Received: by 2002:a5d:5185:: with SMTP id k5mr4309009wrv.341.1570047021557;
        Wed, 02 Oct 2019 13:10:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id 94sm642951wrk.92.2019.10.02.13.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 13:10:20 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190815191929.GA9253@redhat.com>
 <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
Date:   Wed, 2 Oct 2019 22:10:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002170429.GA8189@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 19:04, Jerome Glisse wrote:
> On Wed, Oct 02, 2019 at 06:18:06PM +0200, Paolo Bonzini wrote:
>>>> If the mapping of the source VMA changes, mirroring can update the
>>>> target VMA via insert_pfn.  But what ensures that KVM's MMU notifier
>>>> dismantles its own existing page tables (so that they can be recreated
>>>> with the new mapping from the source VMA)?
>>
>> The KVM inspector process is also (or can be) a QEMU that will have to
>> create its own KVM guest page table.  So if a page in the source VMA is
>> unmapped we want:
>>
>> - the source KVM to invalidate its guest page table (done by the KVM MMU
>> notifier)
>>
>> - the target VMA to be invalidated (easy using mirroring)
>>
>> - the target KVM to invalidate its guest page table, as a result of
>> invalidation of the target VMA
> 
> You can do the target KVM invalidation inside the mirroring invalidation
> code.

Why should the source and target KVMs behave differently?  If the source
invalidates its guest page table via MMU notifiers, so should the target.

The KVM MMU notifier exists so that nothing (including mirroring) needs
to know that there is KVM on the other side.  Any interaction between
KVM page tables and VMAs must be mediated by MMU notifiers, anything
else is unacceptable.

If it is possible to invoke the MMU notifiers around the calls to
insert_pfn, that of course would be perfect.

Thanks,

Paolo
