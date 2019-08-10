Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02B088CC8
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2019 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfHJSfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Aug 2019 14:35:30 -0400
Received: from mout.web.de ([212.227.15.14]:35001 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbfHJSfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Aug 2019 14:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1565462119;
        bh=ClcsgZcBpTWpisq2aBlR99g7Xv6O/DaYowW9PyHr/D0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=djjZFzw3ei+T77kSfSToBPwRi2/p9hyGy9HmQcF/l/0tmwT97JaAwOihGqajBEsv2
         Zp4tu9wPni4Pcg90ll3p8AG0H9sWfpaA2Mbz+6uWz9xM9+a5J9/UJK53vtGtQ/XRBm
         OcJZJ3vt+B/3W7AVVk5LzSzvocGhBr/RUY/TmKvg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.33] ([85.71.157.74]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LoYFm-1iXVj32WLK-00gVkG; Sat, 10
 Aug 2019 20:35:19 +0200
Subject: Re: Re: [PATCH] KVM/nSVM: properly map nested VMCB
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <20190604160939.17031-1-vkuznets@redhat.com>
 <b46872ce-5305-aa25-9593-d882da3c0872@redhat.com>
From:   Jiri Palecek <jpalecek@web.de>
Message-ID: <6282e1bf-1eaa-450d-7f6a-b868ebab09d0@web.de>
Date:   Sat, 10 Aug 2019 20:35:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b46872ce-5305-aa25-9593-d882da3c0872@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:PrKfiV5mxtkabqbPaVWia6IFnx5OzaY5dTBH1LErOTB8pChwSCZ
 psO0ZpsXNC12X9IVse9dw/SuqpLBURF0KKWCSLPcOgjpfnNvakWEBnN5VihWxLMSRLU+scs
 O84JJkJLiVdEdmnE1z9C9BMGomItH66f0xA1K9Kj0tuU1CJpXxqa1DflzLyj5hnI/kiYsxX
 wfDMPvDQMLF8vhRYf2FxQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QPlJry2+Ygs=:s/SvDwrjGjlZvU8QcZ/q9K
 adTRhgEcvQeSylq7mulXIcItqtKGzszIaQ/t1M9ufLCn+GeMH3pQRgin2HfdVhnUeW1HK3Qq1
 ncCgfX13Uon5cBg/A0ZVg+j3ElQFdF0YGRggn0SmxSrUQCtRioD0Zg76Nojf7H7x86X1a+lEh
 LyjHeRSfAjur96NSywDgpSEXrkzVC1aUXslMTqXX4QGH/IKxvtbNBo3r13xtRfaHJt5zjbD11
 S8CwlJYKbWdtMKpHfFKnXccpYLTYixzO/8Q0r52ysDmhx5ZVA+L1P7LIumhoZqjSrjSbGZ+/8
 yLOAxtjL+Ex/rxhT491m+bM90yxCqO5E3xRimz1i+cQSF7PBBXDeun4adpgctkn3Km2petYSk
 EFKmxbOc0QAmnxE87UkjI5xAkNtfejjSQtJcspDq2HRmtm+/6LxMOq+lVxkDK8yItnMTRyGP7
 5/fBb6yEw4xx/ECU8K2oXycnedNiwi6UJSauv4rYES0olHsNlSbuXw3XpVZjA7cYcDvM1HPB2
 uZkM2/frkf/A9qELVmsYblYkwYrNf5jEYP6ofn++Rk6G1UU/J3KmsKU9/ld/2tXda63RKHcrq
 7wVKS8UHhoWHVG352ACbmwlvyJLo9c9hEkLv+b4NNjxXrcuvIhoDV+OmBto9I6ysRjzKbIdgD
 rdjHfbNnvSD6xii0XONKYASdSbliYdkGgHos1wNDYYCBneaEGVJSjqkrMM19NoZD/nTg41QPv
 slAWgDrlp0W06yx80N4Tzlgm28VA3Lil0DvxrZGnhKT/3cpdwuqROQPEu/KJgcQo5r9yZiwjM
 tS2GdjPkiAi1XVMqx56oZVkCD3BN+bZ6UpM2e9U4cSogNJWQpbDO3PF6vuMqzR7bjeZVJnaQl
 Q8pgxgp29/NfpG9ItvchdBzczP0IVfVb+xHOSuDPhNV6eUxhjsJE63x1F/TazzNeWZ6rGMlbm
 NBGkS31PscsWp6vSwCb8/UDBYnxIpz6XMTl4C73ukYbQNEfb3fgxZcWU0Vez8JMFKf4iqNkDY
 jbwuEDoNXHhs3k0zKcMMKpeNutxe+cvqtqgIEZSIcZWkoQvCIP1gLF2ZcwpD5JgTOAX+l1hiP
 ErL8SVGKd6GctOBjvLpIsVPCjIyn56EQeOQsqw0JBfgxIngzW9M4Zuxj5tRbFkSkX3ng6AGUA
 X7r5k=
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 04. 06. 19 19:27, Paolo Bonzini wrote:
> On 04/06/19 18:09, Vitaly Kuznetsov wrote:
>> Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping gue=
st
>> memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter=
 is
>> GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other =
way
>> around.
>>
>> Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping gue=
st memory")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   arch/x86/kvm/svm.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 735b8c01895e..5beca1030c9a 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -3293,7 +3293,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm=
)
>>   				       vmcb->control.exit_int_info_err,
>>   				       KVM_ISA_SVM);
>>
>> -	rc =3D kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(svm->nested.vmcb), &map);
>> +	rc =3D kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
>>   	if (rc) {
>>   		if (rc =3D=3D -EINVAL)
>>   			kvm_inject_gp(&svm->vcpu, 0);
>> @@ -3583,7 +3583,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm=
)
>>
>>   	vmcb_gpa =3D svm->vmcb->save.rax;
>>
>> -	rc =3D kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
>> +	rc =3D kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
>>   	if (rc) {
>>   		if (rc =3D=3D -EINVAL)
>>   			kvm_inject_gp(&svm->vcpu, 0);
>>
> Oops.  Queued, thanks.

Given that this fix didn't make it to 5.2, and its straightforwardness,
could you send it to stable for inclusion?

Regards

 =C2=A0=C2=A0=C2=A0 Jiri Palecek


