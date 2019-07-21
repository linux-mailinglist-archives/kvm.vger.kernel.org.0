Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265586F393
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfGUOBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 10:01:23 -0400
Received: from mout.web.de ([212.227.17.12]:59435 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfGUOBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 10:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563717664;
        bh=sHiUujddSpjw4N/QMuNNTlGI7uWF+DrwsQKzuNJx+Bk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=rYM7VWGYEstgkj5WzNctWiOjwTpkrDcWrMnmNamd016MB9mHHRwELZHc2+vNi0otb
         OpZOa1jiwnp1c91/jik/6FEc3OjcCSO8FJ89u35BotKhUGxDfSG7HE13E+Jk8G7120
         y++37Vagtct8d7++W0yJOcTdw1zOJTtbAgvOmxlw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MEVYz-1heQtF02Th-00Fm30; Sun, 21
 Jul 2019 16:01:04 +0200
Subject: Re: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
 <A65A74C6-0F2D-4751-97CA-43CFC3A3CA63@oracle.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <c464c26b-30d5-b897-4128-8df65a3f80ff@web.de>
Date:   Sun, 21 Jul 2019 16:00:56 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <A65A74C6-0F2D-4751-97CA-43CFC3A3CA63@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JwMDlhx4i3z5/2GYetXnbz4bjoVESyAnCOxmcqGJVSMaqETsM44
 E6fLYxeJyQqlMw/x2v2lOtATlwOaOXfwofWzcrsn79hbhYrzOnCj1FhmKqHIk7w93tvmmvE
 A9vJJAAixkDA9oMdrZdmEKWyDE7koZaTiYHRij19JVsB2C+XNMkn809Cc6HyXlj22NRw+mT
 +h+ybIh5mVF8FCy+qtiUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hovf958iO2M=:IbqBidyJan1SmqhCkum2Jh
 7GDjpLrQ4FqhV/ghFizf3k6nOId9vp0W065L+lNzLAMvSJF1zVckFaa2kR1jsWIQnjPATmt0J
 fbyZXCwcqtZ8otFjysarHIeEuL2A8Z6eConSDRp3lH7h30JaGNkcQIQHVe/kXN/VQ90TBzUqL
 /w4THPcN1ILGdtL/VQAA46iKdDxjXcaJkC5xw0wgPcbQE6Y4wV/zFi2wPgTKepJc8PtUJaD7Y
 cBrjPdkTI357i2OysAIHr2dh7n4ktNS7Js0K8WyafOlm5bq7coDaP0x/bWGVP6BmKzyLFo8sq
 I9Lei4lIC4kVZKykW1R547QhR6ez+yoVzoSckBg2WrnCInM3gOANVOtMaAIE6QLBRvN3WOjRW
 qOIYmBXR9ZVPtWoTT7v3ilBAxg7/QuFfW0kYDnUuv3cY/jQ6WUAGIugVMY/MkNeQ3PMr3i4fy
 997aXZkVm40ETBGCQALxfNKgNog6mPHg/nqdw6rQkbFOg+2rIX5A4rJ8VQ+QQ417w1Z/dS1ou
 ocxp8GRQAN5BrPG/qU321qdIthqcJypCkrTR5gZcuuJie8HZcNEyYw9xhWeyza1QRCEsGE/33
 zYkj5J5PQzc/xqvE8OZ7lHwWQ4B6d0i10WbT65umvWUYVCkoEh1DzdN4PAOw58b2TZHwDtPgz
 Ln2Z03U5N3CozCC7q9YyPDy6BLrYPZ5qZYHgUDCbMlm7rZ4oTBwWPvQsHwWLKVnkkWXLShVPG
 w727Dj7ky+vy43l8RsStNKr74m7q36Dkg84aWp/Nz7tQttVXc9heiyOqYPMO2S6hpsJxrxDGu
 K3L9cYmYBkAlP6boVPqmbiZtw4c4Q43Xs4wL2pVraC8dWmKtmK/p51jaxWP8IqVEoHU9ONZYu
 PlAMdSRvF1z3lOFsbak0atzCh/fQPqJJj6nynEm9t9C4F8cxLJfuiv//WJvyghf7vtmA0I8Of
 jkpHG1LWvNyiRcidlZD1CYz3SpxsIsQB2TDLg9w2wRJLSsN2dapRZNaupKa1UzvQZzlC5nsoZ
 jiOdNQ9NCyCxSdwvELZTZP14ukT8kGY0GBWjE9NIGiWmKuV8fy2OVnLuhXHOowHGjux5pnw8b
 XstS77+YRJUQwvN9ZOOeFsQfOYM24H7bR1d
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.19 13:57, Liran Alon wrote:
>
>
>> On 21 Jul 2019, at 14:52, Jan Kiszka <jan.kiszka@web.de> wrote:
>>
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Letting this pend may cause nested_get_vmcs12_pages to run against an
>> invalid state, corrupting the effective vmcs of L1.
>>
>> This was triggerable in QEMU after a guest corruption in L2, followed b=
y
>> a L1 reset.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>
> Good catch.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> This would have been more easily diagnosed in case free_nested() would N=
ULL cached_vmcs12 and cached_shadow_vmcs12
> after kfree() and add to get_vmcs12() & get_shadow_vmcs12() a relevant B=
UG_ON() call.

The NULL'ifying makes sense, patch follows. But the helpers are too often =
called
unconditionally, thus cause false positives when adding the BUG_ON.

Jan

>
> I would submit such a patch separately.
>
> -Liran
>
>> ---
>>
>> And another gremlin. I'm afraid there is at least one more because
>> vmport access from L2 is still failing in QEMU. This is just another
>> fallout from that. At least the host seems stable now.
>>
>> arch/x86/kvm/vmx/nested.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 0f1378789bd0..4cdab4b4eff1 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -220,6 +220,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
>> 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
>> 		return;
>>
>> +	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
>> +
>> 	vmx->nested.vmxon =3D false;
>> 	vmx->nested.smm.vmxon =3D false;
>> 	free_vpid(vmx->nested.vpid02);
>> --
>> 2.16.4
