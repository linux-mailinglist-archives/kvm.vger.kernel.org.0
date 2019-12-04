Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19AC112FE7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfLDQX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 11:23:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727008AbfLDQX5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 11:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575476635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi3siVzuD0gF9Jfvrp7PZuuqYsCl8OlTBWpf/P1Jdb4=;
        b=c7wZGyMtO0CjaAKMMJgSiBLSfDihIgw+c8m0Q0UEtSysiwsTaDO49dyEVQDfTx4hIjpC2k
        iJn4EPCvvc85XkZrCIHgOMw5gFWriC32Co+CyRai2mxLgxijAPgld/jCao0b80pwJlA1TG
        U2UfIBCatsKwEaOZ35WzaRdSLx8B7qs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-oisfIGxPPY65zC4_vfnz_g-1; Wed, 04 Dec 2019 11:23:54 -0500
Received: by mail-wm1-f71.google.com with SMTP id b131so2366141wmd.9
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 08:23:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zi3siVzuD0gF9Jfvrp7PZuuqYsCl8OlTBWpf/P1Jdb4=;
        b=XoZ8bhzwgUt7sjncgc4OqGVrRsTPSZnGoNAKf6F+gH3cOoeR+eBy67pAOLwm6jSp7G
         tVjC9duX8ap27F57DmBnwP5QWwKBZ35M/Rjs8vU68i8OoZHErMHkfWl4hQjnT2csLc4u
         JPCz2xmNR4rDWAHHCKlaNFPc0s3LHg/Cf5snoycPH+AVfrxRXRvgyM3a93WrwXYVLyAE
         Wg5yvxrweq7QfOPP5FICovqcZQ/xFNKVb6aeuaDllGtAF0y/VuaskORRWZacyS4wnbm+
         BGRtSmEZGReJnc5DUAPMxHtd0nejX5aP2w20KXhtwoChAJaZL/JltJBfXaoVvUoJfsS3
         YGjg==
X-Gm-Message-State: APjAAAU1ajntVl47s96nDck57Pd9OF5saFRLxKRegqDT7biggGL7GMOm
        z+7VuTdsU8ffUDReCyPoRVFPphIxI5Ywl1uScTWrj+/lkLFYqX5CSKd4lGvhP7QuWEVwn5/4NZQ
        kGq3H0ABbH9kp
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr327281wmo.13.1575476633258;
        Wed, 04 Dec 2019 08:23:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqzoFwrdUicKLCGUQqrBsC2FVxrG+lTaEvzg61cWLPm1vNon91CH0Ovxt4OsLfpSLXlAn2oIJA==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr327269wmo.13.1575476633007;
        Wed, 04 Dec 2019 08:23:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id h124sm7729871wme.30.2019.12.04.08.23.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 08:23:52 -0800 (PST)
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Catherine Ho <catherine.hecx@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
 <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com>
 <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
 <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
 <CAEn6zmHnTLZxa6Qv=8oDUPYpRD=rvGxJOLjd8Qb15k9-3U+CKw@mail.gmail.com>
 <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
 <20191204154730.GB498046@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4bec2f12-63d7-928e-2e3e-137c68b2a435@redhat.com>
Date:   Wed, 4 Dec 2019 17:23:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204154730.GB498046@habkost.net>
Content-Language: en-US
X-MC-Unique: oisfIGxPPY65zC4_vfnz_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 16:47, Eduardo Habkost wrote:
> On Wed, Dec 04, 2019 at 04:34:45PM +0100, Paolo Bonzini wrote:
>> On 04/12/19 16:07, Catherine Ho wrote:
>>>> Ok, so the problem is that some MSR didn't exist in that version.  Which
>>> I thought in my platform, the only MSR didn't exist is MSR_IA32_VMX_BASIC
>>> (0x480). If I remove this kvm_msr_entry_add(), everything is ok, the guest can
>>> be boot up successfully.
>>>
>>
>> MSR_IA32_VMX_BASIC was added in kvm-4.10.  Maybe the issue is the
>> _value_ that is being written to the VM is not valid?  Can you check
>> what's happening in vmx_restore_vmx_basic?
> 
> I believe env->features[FEAT_VMX_BASIC] will be initialized to 0
> if the host kernel doesn't have KVM_CAP_GET_MSR_FEATURES.

But the host must have MSR features if the MSRs are added:

        if (kvm_feature_msrs && cpu_has_vmx(env)) {
            kvm_msr_entry_add_vmx(cpu, env->features);
        }

Looks like feature MSRs were backported to 4.14, but
1389309c811b0c954bf3b591b761d79b1700283d and the previous commit weren't.

Paolo

