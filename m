Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1333854
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFCSjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfFCSjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:39:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22BAB300CAC0;
        Mon,  3 Jun 2019 18:39:08 +0000 (UTC)
Received: from [10.40.205.157] (unknown [10.40.205.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50DC110013D9;
        Mon,  3 Jun 2019 18:38:51 +0000 (UTC)
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603140304-mutt-send-email-mst@kernel.org>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <35dc90f3-3eaf-b2c2-a8a9-b7d8a6043f3b@redhat.com>
Date:   Mon, 3 Jun 2019 14:38:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603140304-mutt-send-email-mst@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cfSQOdHyBAa71Ofd0U9ySdm3rw06OprD3"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 03 Jun 2019 18:39:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cfSQOdHyBAa71Ofd0U9ySdm3rw06OprD3
Content-Type: multipart/mixed; boundary="Y5QNV8HrgVfCbdTDlLIOfT8WKVnZvSvIS";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
 wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
 david@redhat.com, dodgen@google.com, konrad.wilk@oracle.com,
 dhildenb@redhat.com, aarcange@redhat.com, alexander.duyck@gmail.com
Message-ID: <35dc90f3-3eaf-b2c2-a8a9-b7d8a6043f3b@redhat.com>
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603140304-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190603140304-mutt-send-email-mst@kernel.org>

--Y5QNV8HrgVfCbdTDlLIOfT8WKVnZvSvIS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/3/19 2:04 PM, Michael S. Tsirkin wrote:
> On Mon, Jun 03, 2019 at 01:03:04PM -0400, Nitesh Narayan Lal wrote:
>> This patch series proposes an efficient mechanism for communicating fr=
ee memory
>> from a guest to its hypervisor. It especially enables guests with no p=
age cache
>> (e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > dis=
k) to
>> rapidly hand back free memory to the hypervisor.
>> This approach has a minimal impact on the existing core-mm infrastruct=
ure.
> Could you help us compare with Alex's series?
> What are the main differences?
I have just started reviewing Alex's series. Once I am done with it, I ca=
n.
>> Measurement results (measurement details appended to this email):
>> * With active page hinting, 3 more guests could be launched each of 5 =
GB(total=20
>> 5 vs. 2) on a 15GB (single NUMA) system without swapping.
>> * With active page hinting, on a system with 15 GB of (single NUMA) me=
mory and
>> 4GB of swap, the runtime of "memhog 6G" in 3 guests (run sequentially)=
 resulted
>> in the last invocation to only need 37s compared to 3m35s without page=
 hinting.
>>
>> This approach tracks all freed pages of the order MAX_ORDER - 2 in bit=
maps.
>> A new hook after buddy merging is used to set the bits in the bitmap.
>> Currently, the bits are only cleared when pages are hinted, not when p=
ages are
>> re-allocated.
>>
>> Bitmaps are stored on a per-zone basis and are protected by the zone l=
ock. A
>> workqueue asynchronously processes the bitmaps as soon as a pre-define=
d memory
>> threshold is met, trying to isolate and report pages that are still fr=
ee.
>>
>> The isolated pages are reported via virtio-balloon, which is responsib=
le for
>> sending batched pages to the host synchronously. Once the hypervisor p=
rocessed
>> the hinting request, the isolated pages are returned back to the buddy=
=2E
>>
>> The key changes made in this series compared to v9[1] are:
>> * Pages only in the chunks of "MAX_ORDER - 2" are reported to the hype=
rvisor to
>> not break up the THP.
>> * At a time only a set of 16 pages can be isolated and reported to the=
 host to
>> avoids any false OOMs.
>> * page_hinting.c is moved under mm/ from virt/kvm/ as the feature is d=
ependent
>> on virtio and not on KVM itself. This would enable any other hyperviso=
r to use
>> this feature by implementing virtio devices.
>> * The sysctl variable is replaced with a virtio-balloon parameter to
>> enable/disable page-hinting.
>>
>> Pending items:
>> * Test device assigned guests to ensure that hinting doesn't break it.=

>> * Follow up on VIRTIO_BALLOON_F_PAGE_POISON's device side support.
>> * Compare reporting free pages via vring with vhost.
>> * Decide between MADV_DONTNEED and MADV_FREE.
>> * Look into memory hotplug, more efficient locking, possible races whe=
n
>> disabling.
>> * Come up with proper/traceable error-message/logs.
>> * Minor reworks and simplifications (e.g., virtio protocol).
>>
>> Benefit analysis:
>> 1. Use-case - Number of guests that can be launched without swap usage=

>> NUMA Nodes =3D 1 with 15 GB memory
>> Guest Memory =3D 5 GB
>> Number of cores in guest =3D 1
>> Workload =3D test allocation program allocates 4GB memory, touches it =
via memset
>> and exits.
>> Procedure =3D
>> The first guest is launched and once its console is up, the test alloc=
ation
>> program is executed with 4 GB memory request (Due to this the guest oc=
cupies
>> almost 4-5 GB of memory in the host in a system without page hinting).=
 Once
>> this program exits at that time another guest is launched in the host =
and the
>> same process is followed. It is continued until the swap is not used.
>>
>> Results:
>> Without hinting =3D 3, swap usage at the end 1.1GB.
>> With hinting =3D 5, swap usage at the end 0.
>>
>> 2. Use-case - memhog execution time
>> Guest Memory =3D 6GB
>> Number of cores =3D 4
>> NUMA Nodes =3D 1 with 15 GB memory
>> Process: 3 Guests are launched and the =E2=80=98memhog 6G=E2=80=99 exe=
cution time is monitored
>> one after the other in each of them.
>> Without Hinting - Guest1:47s, Guest2:53s, Guest3:3m35s, End swap usage=
: 3.5G
>> With Hinting - Guest1:40s, Guest2:44s, Guest3:37s, End swap usage: 0
>>
>> Performance analysis:
>> 1. will-it-scale's page_faul1:
>> Guest Memory =3D 6GB
>> Number of cores =3D 24
>>
>> Without Hinting:
>> tasks,processes,processes_idle,threads,threads_idle,linear
>> 0,0,100,0,100,0
>> 1,315890,95.82,317633,95.83,317633
>> 2,570810,91.67,531147,91.94,635266
>> 3,826491,87.54,713545,88.53,952899
>> 4,1087434,83.40,901215,85.30,1270532
>> 5,1277137,79.26,916442,83.74,1588165
>> 6,1503611,75.12,1113832,79.89,1905798
>> 7,1683750,70.99,1140629,78.33,2223431
>> 8,1893105,66.85,1157028,77.40,2541064
>> 9,2046516,62.50,1179445,76.48,2858697
>> 10,2291171,58.57,1209247,74.99,3176330
>> 11,2486198,54.47,1217265,75.13,3493963
>> 12,2656533,50.36,1193392,74.42,3811596
>> 13,2747951,46.21,1185540,73.45,4129229
>> 14,2965757,42.09,1161862,72.20,4446862
>> 15,3049128,37.97,1185923,72.12,4764495
>> 16,3150692,33.83,1163789,70.70,5082128
>> 17,3206023,29.70,1174217,70.11,5399761
>> 18,3211380,25.62,1179660,69.40,5717394
>> 19,3202031,21.44,1181259,67.28,6035027
>> 20,3218245,17.35,1196367,66.75,6352660
>> 21,3228576,13.26,1129561,66.74,6670293
>> 22,3207452,9.15,1166517,66.47,6987926
>> 23,3153800,5.09,1172877,61.57,7305559
>> 24,3184542,0.99,1186244,58.36,7623192
>>
>> With Hinting:
>> 0,0,100,0,100,0
>> 1,306737,95.82,305130,95.78,306737
>> 2,573207,91.68,530453,91.92,613474
>> 3,810319,87.53,695281,88.58,920211
>> 4,1074116,83.40,880602,85.48,1226948
>> 5,1308283,79.26,1109257,81.23,1533685
>> 6,1501987,75.12,1093661,80.19,1840422
>> 7,1695300,70.99,1104207,79.03,2147159
>> 8,1901523,66.85,1193613,76.90,2453896
>> 9,2051288,62.73,1200913,76.22,2760633
>> 10,2275771,58.60,1192992,75.66,3067370
>> 11,2435016,54.48,1191472,74.66,3374107
>> 12,2623114,50.35,1196911,74.02,3680844
>> 13,2766071,46.22,1178589,73.02,3987581
>> 14,2932163,42.10,1166414,72.96,4294318
>> 15,3000853,37.96,1177177,72.62,4601055
>> 16,3113738,33.85,1165444,70.54,4907792
>> 17,3132135,29.77,1165055,68.51,5214529
>> 18,3175121,25.69,1166969,69.27,5521266
>> 19,3205490,21.61,1159310,65.65,5828003
>> 20,3220855,17.52,1171827,62.04,6134740
>> 21,3182568,13.48,1138918,65.05,6441477
>> 22,3130543,9.30,1128185,60.60,6748214
>> 23,3087426,5.15,1127912,55.36,7054951
>> 24,3099457,1.04,1176100,54.96,7361688
>>
>> [1] https://lkml.org/lkml/2019/3/6/413
>>
--=20
Regards
Nitesh


--Y5QNV8HrgVfCbdTDlLIOfT8WKVnZvSvIS--

--cfSQOdHyBAa71Ofd0U9ySdm3rw06OprD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz1aTgACgkQo4ZA3AYy
ozn94g/7BeA8NfDTR9E50Fp31nZvDDzLUoiCaM8gOvxvp4UWiW6wuFUgOH3+1Vc9
5EeMQm9jEnCE0ShOoa9NFk+ZYxdIVeno63V8pPn6qmNQiGPJPHxoOODwKv7wUezU
1y4J7YF+XOrLwBeCm7rAus9ZwJzJozDk/nkXs56RowX7wA6KR+H8lOabq5xvk3zn
n/9f6ZXCCB3V1WxJilJ5os9Lye2mN00urUeWeg8LKtV9jsnOa0pREqsmzdmipZCP
YA/lxT/C6EskSvbcXGG/TkO5LXlgrWRNA7sokh2uDsXGMmUXSO7kN5xmcEDbUohq
3ROBxr+TS56fQnYeXFAgGUdFq1cGZCd9Q8UA16DwGkjfmbMLrYamXE4ccBhm+zIE
FtZA3BqT6JY+kkVDnCm6f8zK4zXkISYK1uQekaKoa9iphBk7yf/dyFo5+D7xMqeg
4w6nz0KahiePt/V2I13nrtLiiI6GNKoZOw99CFw7UQkPySfHMxEIprqizBdS2MUF
/csn78iT/2tMIlcge2pR4xAguJumORY0tUNXIT8Xj1RM/G7YLw8mINeqztWq9Bto
yiaPmt3C9Wn8HkFZJTc+DbZQcXsLo3Cldy9Ea3FRcr/WgU6rESl4hxwFrJWu9G+q
YWFeG7CKDtk8nP4uH7+hBXW90tZFztw4egk/fYPA/6paW+67Qkg=
=CEiI
-----END PGP SIGNATURE-----

--cfSQOdHyBAa71Ofd0U9ySdm3rw06OprD3--
