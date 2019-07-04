Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30505F7FB
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfGDMYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:24:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39367 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfGDMYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:24:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so5947320wma.4
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 05:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KPSqPEoe1r6Dxc7vF7+sN1C5dmgHnFsD6yHp+UiwzX4=;
        b=R2LQnTBn18iaE0a0WR+tnpzBzFRB1X0m82PMCy1pu+2AsAa2rWJhx33G5T8l18WMPK
         0UtRB0721dq6Y4gjxKWEDd+LYIciTHcOuIUrD8x+DlKbh+n8dPF4emo/hcp6oxYhYkh5
         wMvxovXuh6nMmC1Gd9KppTtXizGNEUhWuhOnDBUGRtkejjWHzNQKeN56Asfj+Qhzttnt
         5/aiJp/hGiM97wNLHsCM6DRUrEI3b95AkgiQfDJqbtj9uxNzL3TnyoRr5y1e7XX7dlnc
         AcBXdKBOxK0tmUWqNSx36Bu/ZScza58H2EcGN0A88sqrF4Hjej1X5ctxDphPHReBlsDP
         G5oA==
X-Gm-Message-State: APjAAAW1PdbPk2xsuquVOXcGCpUKY3u4ifh19QD4H3xaTeo0t3nCvPw1
        RLi6Mo9wIAvUVrS06FI6BVL3qrEPAsDByQ==
X-Google-Smtp-Source: APXvYqzQG/PaUQQ9qHqVztBsqXVCipBrlmnMaYGswHNZvR/NBHYz4F7WBJigYoQ5tyRLPoX0TXFIMA==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr12390007wmf.20.1562243084421;
        Thu, 04 Jul 2019 05:24:44 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id g131sm3675169wmf.37.2019.07.04.05.24.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:24:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <cdall@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
        Zhang Lei <zhang.lei@jp.fujitsu.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        kvm <kvm@vger.kernel.org>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <86wogynrbt.wl-marc.zyngier@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
Date:   Thu, 4 Jul 2019 14:24:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <86wogynrbt.wl-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 10:20, Marc Zyngier wrote:
> +KVM, Paolo and Radim,
> 
> Guys, do you mind picking this single patch and sending it to Linus?
> That's the only fix left for 5.2. Alternatively, I can send you a pull
> request, but it feels overkill.

Sure, will do.

Paolo

> Either way, please let me know.
> 
> Thanks,
> 
> 	M.
> 
> On Wed, 03 Jul 2019 18:42:50 +0100,
> Dave Martin <Dave.Martin@arm.com> wrote:
>>
>> From: Zhang Lei <zhang.lei@jp.fujitsu.com>
>>
>> The original implementation of vq_present() relied on aggressive
>> inlining in order for the compiler to know that the code is
>> correct, due to some const-casting issues.  This was causing sparse
>> and clang to complain, while GCC compiled cleanly.
>>
>> Commit 0c529ff789bc addressed this problem, but since vq_present()
>> is no longer a function, there is now no implicit casting of the
>> returned value to the return type (bool).
>>
>> In set_sve_vls(), this uncast bit value is compared against a bool,
>> and so may spuriously compare as unequal when both are nonzero.  As
>> a result, KVM may reject valid SVE vector length configurations as
>> invalid, and vice versa.
>>
>> Fix it by forcing the returned value to a bool.
>>
>> Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
>> Fixes: 0c529ff789bc ("KVM: arm64: Implement vq_present() as a macro")
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com> [commit message rewrite]
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> ---
>>
>> Posting this under Zhang Lei's authorship, due to the need to turn this
>> fix around quickly.  The fix is as per the original suggestion [1].
>>
>> Originally observed with the QEMU KVM SVE support under review:
>> https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
>>
>> Bug reproduced and fix tested on the Arm Fast Model, with
>> http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve/v3/head
>> (After rerunning util/update_headers.sh.)
>>
>> (the --sve-vls command line argument was removed in v4 of the
>> kvmtool patches).
>>
>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-July/664633.html
>> ---
>>  arch/arm64/kvm/guest.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index c2afa79..dfd6264 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>  
>>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
>>  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
>> -#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
>> +#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
>>  
>>  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>  {
>> -- 
>> 2.1.4
>>
> 

