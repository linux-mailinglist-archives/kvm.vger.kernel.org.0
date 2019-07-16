Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43F26B0C0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 23:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388616AbfGPVJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 17:09:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45124 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731273AbfGPVJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 17:09:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so22400672wre.12
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2019 14:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ph3IVC3avkK9m7SP4JVhBgpCnO3Je1f1imGTT1xbtj0=;
        b=DQmYTZUNdQ9MVbTM933L1c1cw+x56DUDeVt2Dk+J27MRTRILyDZx7dT/NnbO91CDiP
         desK8JWoq+0G7jx3EtIGILyLqHb69eBGPyhrlze/3J/Jf2w9pbAK80D2ipBCTNxnsrDu
         ZFFbOxya0UkUATlwr73PoX6a5AG4UQMMUkCtaoBFgpqo5f54zn47XnGDLYJAOwDBBbqB
         o5Nl/IWfsvZHULtJ54pDxETpyAqccPe/G1LDNfEIBo0HPQBht7UMSAT7dS1ZQHupSp1h
         R57LBc3kHh7+1nZ1DAEwH/y2R5yPS/BvqJFswP+k2oiZlu9YEaZt9bQ20d8IYmPHuLI4
         pbyQ==
X-Gm-Message-State: APjAAAXujCbnJV8xkxqYw86q3bmm5htv4kEtuBqnEUyjomDEDbDZCVeQ
        3wEJO35M8UubuB/RXf647zshcA==
X-Google-Smtp-Source: APXvYqwrTEjR7Sq79t4rs8fZ/nUY/V/3gOKq1qgd333KXslym0csJvmn0X726MssZLnS6/mYmVUiwQ==
X-Received: by 2002:adf:e841:: with SMTP id d1mr38401760wrn.204.1563311344946;
        Tue, 16 Jul 2019 14:09:04 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j10sm36429573wrd.26.2019.07.16.14.09.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 14:09:04 -0700 (PDT)
Subject: Re: [Qemu-devel] [patch QEMU] kvm: i386: halt poll control MSR
 support
To:     Mark Kanda <mark.kanda@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190603230408.GA7938@amt.cnet>
 <1afdac17-3f86-5e5b-aebc-5311576ddefb@redhat.com>
 <0c40f676-a2f4-bb45-658e-9758fd02ce36@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <86e64a5c-bb2b-00c8-56c3-722c9b8f9db6@redhat.com>
Date:   Tue, 16 Jul 2019 23:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0c40f676-a2f4-bb45-658e-9758fd02ce36@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 21:52, Mark Kanda wrote:
> 
> As such, I think we should only enable halt polling if it is supported
> on the host - see the attached patch.
> 
> ...thoughts?

No, it should not be enabled by default at all, at least not until we
can require kernel 5.2.  My mistake, sorry.  Can you post a patch?

Paolo
