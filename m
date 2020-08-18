Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988D1247E8A
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 08:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHRGiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 02:38:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726466AbgHRGip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 02:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597732723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5II9TR/Y+3Xr8L8jFb68b8c/+N16s3bd5AiKNgRElk=;
        b=hQ1LfwHj/IalEOmGHqYbb7JLgxDcwKKV6ybbwjpw0OR5LSPbiRh/y83u8iA3lfljCCIEgJ
        ZAWhdR3a6YD/CQlXy7Y3V7j+y8k2akyEdIUXDwzxiIIypP1Hj706hiYV2YBEdNSdctOjax
        gW3XcZ1oVAOjxm2597SMvjBeFOBC5LA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-qYiI4r3KMbG91MlxPv_EmA-1; Tue, 18 Aug 2020 02:38:42 -0400
X-MC-Unique: qYiI4r3KMbG91MlxPv_EmA-1
Received: by mail-wm1-f71.google.com with SMTP id g72so5696463wme.4
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 23:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5II9TR/Y+3Xr8L8jFb68b8c/+N16s3bd5AiKNgRElk=;
        b=jOIMHlhycWUHJaofnMYpw8Eol0Rgdxff3/l92jnwQHwE7JBKYUcHtS4D5CYd7kwRM4
         hGKBDfwIS18v5lxWhcoeExTedecejEkSuaSXh+CVfrCcNTy3O4awMHpErcF8P/O8RC4n
         hcibD1SAvijULdtOaqY19ZLbS5OB2NPifbVmRzZzUsMjO4gajNuAyG2c0zg4YnMWvFxt
         N3lPm6yRdWpLZAGc7cguQfpHUFVtYGbmwVSn8EdV5yyx8d6gVFynEMJAwYI2YS+BZIta
         V8iHJd0q8hEpLstvAQ2J/7aShOJWAeYOQe7NKDTURyXb7KdIKjt/YxxyizdcSkROQEl6
         eqdw==
X-Gm-Message-State: AOAM531xKcsXnkxk+qFKJzf5sYDRdBpa0CP9KUKK8c4T4oOgbcPxTYRJ
        0JyctnaXDEKdhU/cGgjU5oeiXOJy4MPSn6DOQLitn6l+p2dAifi4pWsUA2El5RTjJN7woP1K5Fk
        leMkIn+gfsvwP
X-Received: by 2002:a1c:f017:: with SMTP id a23mr2340420wmb.164.1597732721140;
        Mon, 17 Aug 2020 23:38:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjS2qUo8opm1lsZazDt4pDgWBLfEn1wuz2OpNPHDBpFCywfBpalzOYfrb09HXWZK0sIk7f9A==
X-Received: by 2002:a1c:f017:: with SMTP id a23mr2340405wmb.164.1597732720921;
        Mon, 17 Aug 2020 23:38:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id h11sm33850848wrb.68.2020.08.17.23.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 23:38:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Nadav Amit <namit@vmware.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
 <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
 <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
 <CALMp9eSoRSKBvNwjm5fpPG2XDJnnC1b-tm68P-K_Jnyab4aPMg@mail.gmail.com>
 <4bb7c975-70dd-0247-3824-973229f3337b@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02cab471-0023-08f9-1722-2d42a3686a50@redhat.com>
Date:   Tue, 18 Aug 2020 08:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4bb7c975-70dd-0247-3824-973229f3337b@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 01:13, Krish Sadhukhan wrote:
>>
> 
> I did some experiments on the processor behavior on an Epyc 2 system via
> KVM:
> 
> Â Â  1. MBZ bits:Â  VMRUN passes even if these bits are set to 1 and
> guest is exiting with exit code of Â Â Â  Â Â Â  Â Â  SVM_EXIT_VMMCALL.
> According to the APM, this settting should constitute an invalid guest
> state and hence I should get and exit code of SVM_EXIT_ERR. There's no
> KVM check in place for these CR3 bits, so the check is all done in
> hardware.
> 
> Â Â  2. non-MBZ reserved bits:Â  Based on Nadav Amit's suggestion, I set
> the 'not present' bit in an upper level NPT in order to trigger an NPF
> and I did get an exit code of SVM_EXIT_NPF when I set any of these bits.
> I am hoping that the processor has done the consistency check before it
> tripped on NPF and not the other way around, so that our test is useful :
> 
> Â Â Â  In PAE-legacy and non-PAE-legacy modes, the guest doesn't exit
> with SVM_EXIT_VMMCALL when these bits are set to 0. I am not sure if I
> am missing any special setting for the PAE-legacy and non-PAE-legacy
> modes. In long-mode, however, the processor seems to behave as per APM,
> i.e., guest exits with SVM_EXIT_VMMCALL when these bits are set to 0.

Are you going to send patches for this?

Thanks,

Paolo

