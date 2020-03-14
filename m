Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23171857F5
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 02:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgCOBwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 21:52:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbgCOBwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Mar 2020 21:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584237124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNGxzRLoJwPeqvl0qjjNKyQm8VTvsM9D2d2AbN/+Uu8=;
        b=YEuFy1W/8HYOyv7lO3pjB76BemAHbGZiww0vv8pBIZ09SpTfjX2AH4Gjkb+SfUs9szoHTs
        wYZbbCjWjUJQ107FBtwN6AGv5WKLT2v8QOjl5Ex5e60SqfwgBL1teerpEBZu8YXI0yBEbT
        K0LVnLPmYLVdVVoHFslmPBYFfjs6g7w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-M0w-EP7hMRq5eYJOJe2PkA-1; Sat, 14 Mar 2020 05:48:11 -0400
X-MC-Unique: M0w-EP7hMRq5eYJOJe2PkA-1
Received: by mail-wm1-f69.google.com with SMTP id t2so3506937wmj.2
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 02:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=bNGxzRLoJwPeqvl0qjjNKyQm8VTvsM9D2d2AbN/+Uu8=;
        b=C7au6NpFhghXDnP6ZIlN9uab94t7cscHp4/CtsPq1RKXrvpuIohrzNNeX/Ox0z0DPo
         cY4YV5GIL+W+LAL8naDWktGmhka+mL39qXxW0cwIHeiN5mn43EDs570RVD2iJ5l8TsV6
         PxMebzU+CcYzuWhQy4sFfA3AYcEa+j/vL3bTpgba4WaxZikM4rJxCO7R2lKTzvGRIuZg
         YKdzDV4A8BDPiCWTchjOuUBKwcc5wPzEKRu0PT8su8rvRF/Z0dZGvfPCfeVNoGIxmGq3
         WG05ORlKCVQBDUQ34GUuhxa/fGFOdBf1cYq/NehOTSY/UM+xhYUxDXWJjMBu50997TA3
         nkBg==
X-Gm-Message-State: ANhLgQ1qb5Bst/W69Ae96hMy+HZl++3/EWZAs5s2eMBSchNj9GMR9FIf
        E71jSZ3Jj+ScdkbycKHUWkjlHUv+JYwHaN5s5oowxA835IRsY9Hjt83Ir2AjHWzdwiw6ZhE8uOd
        avGOgmRmW4SQT
X-Received: by 2002:adf:bb06:: with SMTP id r6mr14893644wrg.324.1584179290509;
        Sat, 14 Mar 2020 02:48:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt0vPH6mqrPR73DWT29nJZkdZ4BIosN3HBohHEZGvUyHoikP6cWyte5u5P+OvjhbeSmb9QPFQ==
X-Received: by 2002:adf:bb06:: with SMTP id r6mr14893623wrg.324.1584179290274;
        Sat, 14 Mar 2020 02:48:10 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id y3sm47651288wrm.46.2020.03.14.02.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 02:48:09 -0700 (PDT)
Subject: Re: [Patch v2] KVM: x86: Initializing all kvm_lapic_irq fields in
 ioapic_write_indirect
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        peterx@redhat.com
References: <1584105384-4864-1-git-send-email-nitesh@redhat.com>
 <871rpwpesg.fsf@vitty.brq.redhat.com>
 <29c41f43-a8c6-3d72-8647-d46782094524@redhat.com>
 <e20e4fb5-247c-a029-e09f-49f83f2f9d1a@redhat.com>
 <87v9n8mdn0.fsf@vitty.brq.redhat.com>
 <66c57868-52dd-94cc-e9ef-7bceb54a65e3@redhat.com>
 <87r1xwmct1.fsf@vitty.brq.redhat.com>
 <6052eb34-3b70-35c1-2622-440bdfc43f16@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4acfacb2-9509-0f1d-24d8-dbbda1944088@redhat.com>
Date:   Sat, 14 Mar 2020 10:45:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6052eb34-3b70-35c1-2622-440bdfc43f16@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Nnzu5rtYW0HMuYYQBtmdqSAyrshoJcsvn"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nnzu5rtYW0HMuYYQBtmdqSAyrshoJcsvn
Content-Type: multipart/mixed; boundary="Amx3acUXpJRkBSfsPH5YccsbVB34LglkS"

--Amx3acUXpJRkBSfsPH5YccsbVB34LglkS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/03/20 17:38, Nitesh Narayan Lal wrote:
>=20
> On 3/13/20 12:36 PM, Vitaly Kuznetsov wrote:
>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>
>>> On 3/13/20 12:18 PM, Vitaly Kuznetsov wrote:
>>>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>>>
>>>>> On 3/13/20 9:38 AM, Nitesh Narayan Lal wrote:
>>>>>> On 3/13/20 9:25 AM, Vitaly Kuznetsov wrote:
>>>>>>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>>>>>>
>>>>>>>> Previously all fields of structure kvm_lapic_irq were not initia=
lized
>>>>>>>> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will c=
ause
>>>>>>>> an issue when any of those fields are used for processing a requ=
est.
>>>>>>>> For example not initializing the msi_redir_hint field before pas=
sing
>>>>>>>> to the kvm_bitmap_or_dest_vcpus(), may lead to a misbehavior of
>>>>>>>> kvm_apic_map_get_dest_lapic(). This will specifically happen whe=
n the
>>>>>>>> kvm_lowest_prio_delivery() returns TRUE due to a non-zero garbag=
e
>>>>>>>> value of msi_redir_hint, which should not happen as the request =
belongs
>>>>>>>> to APIC fixed delivery mode and we do not want to deliver the
>>>>>>>> interrupt only to the lowest priority candidate.
>>>>>>>>
>>>>>>>> This patch initializes all the fields of kvm_lapic_irq based on =
the
>>>>>>>> values of ioapic redirect_entry object before passing it on to
>>>>>>>> kvm_bitmap_or_dest_vcpus().
>>>>>>>>
>>>>>>>> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request t=
o target vCPUs")
>>>>>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>>>>>>> ---
>>>>>>>>  arch/x86/kvm/ioapic.c | 7 +++++--
>>>>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>>>>>>>> index 7668fed..3a8467d 100644
>>>>>>>> --- a/arch/x86/kvm/ioapic.c
>>>>>>>> +++ b/arch/x86/kvm/ioapic.c
>>>>>>>> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct k=
vm_ioapic *ioapic, u32 val)
>>>>>>>>  		if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
>>>>>>>>  			struct kvm_lapic_irq irq;
>>>>>>>> =20
>>>>>>>> -			irq.shorthand =3D APIC_DEST_NOSHORT;
>>>>>>>>  			irq.vector =3D e->fields.vector;
>>>>>>>>  			irq.delivery_mode =3D e->fields.delivery_mode << 8;
>>>>>>>> -			irq.dest_id =3D e->fields.dest_id;
>>>>>>>>  			irq.dest_mode =3D
>>>>>>>>  			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>>>>>>> +			irq.level =3D 1;
>>>>>>> 'level' is bool in struct kvm_lapic_irq but other than that, is t=
here a
>>>>>>> reason we set it to 'true' here? I understand that any particular=

>>>>>>> setting is likely better than random
>>>>>> Yes, that is the only reason which I had in my mind while doing th=
is change.
>>>>>> I was not particularly sure about the value, so I copied what ioap=
ic_serivce()
>>>>>> is doing.
>>>>> Do you think I should skip setting this here?
>>>>>
>>>> Personally, i'd initialize it to 'false': usualy, if something is no=
t
>>>> properly initialized it's either 0 or garbage)
>>> I think that's true, initializing it to 'false' might make more sense=
=2E
>>> Any other concerns or comments that I can improve?
>>>
>> Please add the missing space to the 'Fixes' tag:
>>
>> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to tar=
get vCPUs")
>=20
> My bad.
>=20
>>
>> and with that and irq.level initialized to 'false' feel free to add
>>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> tag. Thanks!
>=20
> Sure, thank you.

I did the changes and applied the patch, thanks.

Paolo



--Amx3acUXpJRkBSfsPH5YccsbVB34LglkS--

--Nnzu5rtYW0HMuYYQBtmdqSAyrshoJcsvn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl5sp9YACgkQv/vSX3jH
roNLqQf/U3ykM9g/UnYCotH4sshiuuyg7+71DBQRVTYPG5ollo4wsrGOIMYCypsq
kJn/GzAz7ey2VQ+Z3IMgNXslcLcZBsIXISV1LMh1a7CxgxubzaUVMHqRhkMo7o5+
iCbUmsNZVPCNLCG47XmO6pXZAw3J2rojTNgLfYNjRCyTYmtkxL/XSUcoUBFmNzG0
h5Dlc1vtatkb47IR5VtDHfFdZMBbHoSqujA+wEtcrMJIlPAU9DUwdUVcqzSQcpLp
oh0QaSS7DttuMmGe3ji6Q4NnblKlSu238dTVWa1JHjkNxugObu4/UdNCl5Z440sa
jcKQDIrefkvDQML04o+69KiEVyP8vA==
=ZTrG
-----END PGP SIGNATURE-----

--Nnzu5rtYW0HMuYYQBtmdqSAyrshoJcsvn--

