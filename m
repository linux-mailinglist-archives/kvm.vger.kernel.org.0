Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10191FDC7E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKOLqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:46:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59391 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727122AbfKOLqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:46:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573818371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=yzZ0jtfn5strM3JCjjkGB7EUskXptCWUnHPIG0tX/HQ=;
        b=BGAryzbO5ymQF1dc4+iPEA3/d14O/u+S8R5g6PItYIrolFDjksrYuxOg5BaTWCoLwilT4A
        5qLmT3D+FTg18nJSh/yViwm4urCj8aF2b72MAPUQWxq6fQG6mkq9rXutMFN0eusxBX5+Dz
        Ud4huzbr7+R2xWY9NnbbUlkxC4ht2LI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-Xc862GAZOhipUkmiDNaT7g-1; Fri, 15 Nov 2019 06:46:06 -0500
X-MC-Unique: Xc862GAZOhipUkmiDNaT7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7440E1802CE3;
        Fri, 15 Nov 2019 11:46:05 +0000 (UTC)
Received: from [10.10.120.209] (ovpn-120-209.rdu2.redhat.com [10.10.120.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 673285ED37;
        Fri, 15 Nov 2019 11:45:55 +0000 (UTC)
Subject: Re: [Patch v2 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
References: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
 <1573131223-5685-3-git-send-email-nitesh@redhat.com>
 <62be5025-374b-6837-77dd-05ab2148f295@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <26daac23-6605-07ee-48f1-f8941fc02f64@redhat.com>
Date:   Fri, 15 Nov 2019 06:45:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <62be5025-374b-6837-77dd-05ab2148f295@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ev9yP9NJVJptF3vr9kX3lQaV6rVqg1Mns"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ev9yP9NJVJptF3vr9kX3lQaV6rVqg1Mns
Content-Type: multipart/mixed; boundary="8WXuoP5PpXUDATB37YahWdinwChXZKhVS";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mtosatti@redhat.com, rkrcmar@redhat.com,
 vkuznets@redhat.com, sean.j.christopherson@intel.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org
Message-ID: <26daac23-6605-07ee-48f1-f8941fc02f64@redhat.com>
Subject: Re: [Patch v2 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
References: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
 <1573131223-5685-3-git-send-email-nitesh@redhat.com>
 <62be5025-374b-6837-77dd-05ab2148f295@redhat.com>
In-Reply-To: <62be5025-374b-6837-77dd-05ab2148f295@redhat.com>

--8WXuoP5PpXUDATB37YahWdinwChXZKhVS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 11/15/19 5:26 AM, Paolo Bonzini wrote:
> On 07/11/19 13:53, Nitesh Narayan Lal wrote:
>> In IOAPIC fixed delivery mode instead of flushing the scan
>> requests to all vCPUs, we should only send the requests to
>> vCPUs specified within the destination field.
>>
>> This patch introduces kvm_get_dest_vcpus_mask() API which
>> retrieves an array of target vCPUs by using
>> kvm_apic_map_get_dest_lapic() and then based on the
>> vcpus_idx, it sets the bit in a bitmap. However, if the above
>> fails kvm_get_dest_vcpus_mask() finds the target vCPUs by
>> traversing all available vCPUs. Followed by setting the
>> bits in the bitmap.
> Queued, thanks.  I just took the liberty of renaming the function to
> kvm_bitmap_or_dest_vcpus.

Sure, thank you.

>
> Paolo
>
--=20
Nitesh


--8WXuoP5PpXUDATB37YahWdinwChXZKhVS--

--ev9yP9NJVJptF3vr9kX3lQaV6rVqg1Mns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl3Oj/AACgkQo4ZA3AYy
ozka4hAAlgxk+Nnrf668+xD1uOLtFPhZjA3C29qtTGzZDxL6SkQj/GVVCcN42Vi9
0wKGeZSuVkFd7DJbtn/u1WQNCSahOIzqSrJ4HNTBcqxe/X+ZaIBha9cgBFa2djvy
GjCbKZ0ZIVEc17wprQJoICWNWqqsLxMctQWrjlVDVQbHAwV0qHqq2wdnr0TkU+Hy
IaclxBlIMpNjVUjpdJlj2zFphXDwrMB0sTsf5c7KTqmxoSnaWVxgXeJS3HD9MLQ4
08+jQFekiu98u5VrmnTOgrMr9mThip3gQlVs7WG5VWJHT+Q/yDjZu4r6ZDHlxB2K
YfdMOo9vRgbk+XxaxyIa2q2T+ciar8ZK7llBkGOziTf3N6IWO5CMARpO2DV1dEZH
Hw/OCFuOKFh7H0e06aPF3YZiX72PWPsKxLu7Yyl0l/9IC/wmU6qqa7Q5Fh5HsTwc
T/5VBcklFsYWEEVgRXeip7XLjrDNVkv1uGRvEtkCY5crLZU23iSiDygqcFvwYlFH
EGlw/NQw/tXiKL0nSSAA+LW7sIKLFiDJCyR+s0goT2b83qAlAKX+mqDMK5SjMg/D
/Q26kiBtTnPrnPFOfskQ5IVYaZIpT1yAjAGBFNrXpvS1RiD7gCRqJybfFZipeVp6
BkUAnvcsvEKqBcICiMwhErxwlHJYQCt0TYtEwyxp5oY01gbU7vs=
=gN4K
-----END PGP SIGNATURE-----

--ev9yP9NJVJptF3vr9kX3lQaV6rVqg1Mns--

