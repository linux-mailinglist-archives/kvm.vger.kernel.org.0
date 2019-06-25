Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC55155278
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 16:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbfFYOtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 10:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbfFYOtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 10:49:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DA3E2F8BEC;
        Tue, 25 Jun 2019 14:49:11 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 963731001B04;
        Tue, 25 Jun 2019 14:48:54 +0000 (UTC)
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
Message-ID: <afac6f92-74f5-4580-0303-12b7374e5011@redhat.com>
Date:   Tue, 25 Jun 2019 10:48:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603140304-mutt-send-email-mst@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rug7ZBWQqUMRKhRW0eh0Qepg46M4EzdPQ"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 25 Jun 2019 14:49:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rug7ZBWQqUMRKhRW0eh0Qepg46M4EzdPQ
Content-Type: multipart/mixed; boundary="iJbTV8Ak743uMLzLdbJPIQktYZIfzhuCY";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
 wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
 david@redhat.com, dodgen@google.com, konrad.wilk@oracle.com,
 dhildenb@redhat.com, aarcange@redhat.com, alexander.duyck@gmail.com
Message-ID: <afac6f92-74f5-4580-0303-12b7374e5011@redhat.com>
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603140304-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190603140304-mutt-send-email-mst@kernel.org>

--iJbTV8Ak743uMLzLdbJPIQktYZIfzhuCY
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
Results on comparing the benefits/performance of Alexander's v1
(bubble-hinting)[1], Page-Hinting (includes some of the upstream
suggested changes on v10) over an unmodified Kernel.

Test1 - Number of guests that can be launched without swap usage.
Guest size: 5GB
Cores: 4
Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
Process: Guest is launched sequentially after running an allocation
program with 4GB request.

Results:
unmodified kernel: 2 guests without swap usage and 3rd guest with a swap
usage of 2.3GB.
bubble-hinting v1: 4 guests without swap usage and 5th guest with a swap
usage of 1MB.
Page-hinting: 5 guests without swap usage and 6th guest with a swap
usage of 8MB.


Test2 - Memhog execution time
Guest size: 6GB
Cores: 4
Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
Process: 3 guests are launched and "time memhog 6G" is launched in each
of them sequentially.

Results:
unmodified kernel: Guest1-40s, Guest2-1m5s, Guest3-6m38s (swap usage at
the end-3.6G)
bubble-hinting v1: Guest1-32s, Guest2-58s, Guest3-35s (swap usage at the
end-0)
Page-hinting: Guest1-42s, Guest2-47s, Guest3-32s (swap usage at the end-0=
)


Test3 - Will-it-scale's page_fault1
Guest size: 6GB
Cores: 24
Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)

unmodified kernel:
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,459168,95.83,459315,95.83,459315
2,956272,91.68,884643,91.72,918630
3,1407811,87.53,1267948,87.69,1377945
4,1755744,83.39,1562471,83.73,1837260
5,2056741,79.24,1812309,80.00,2296575
6,2393759,75.09,2025719,77.02,2755890
7,2754403,70.95,2238180,73.72,3215205
8,2947493,66.81,2369686,70.37,3674520
9,3063579,62.68,2321148,68.84,4133835
10,3229023,58.54,2377596,65.84,4593150
11,3337665,54.40,2429818,64.01,5052465
12,3255140,50.28,2395070,61.63,5511780
13,3260721,46.11,2402644,59.77,5971095
14,3210590,42.02,2390806,57.46,6430410
15,3164811,37.88,2265352,51.39,6889725
16,3144764,33.77,2335028,54.07,7349040
17,3128839,29.63,2328662,49.52,7808355
18,3133344,25.50,2301181,48.01,8267670
19,3135979,21.38,2343003,43.66,8726985
20,3136448,17.27,2306109,40.81,9186300
21,3130324,13.16,2403688,35.84,9645615
22,3109883,9.04,2290808,36.24,10104930
23,3136805,4.94,2263818,35.43,10564245
24,3118949,0.78,2252891,31.03,11023560

bubble-hinting v1:
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,292183,95.83,292428,95.83,292428
2,540606,91.67,501887,91.91,584856
3,821748,87.53,735244,88.31,877284
4,1033782,83.38,839925,85.59,1169712
5,1261352,79.25,896464,83.86,1462140
6,1459544,75.12,1050094,80.93,1754568
7,1686537,70.97,1112202,79.23,2046996
8,1866892,66.83,1083571,78.48,2339424
9,2056887,62.72,1101660,77.94,2631852
10,2252955,58.57,1097439,77.36,2924280
11,2413907,54.40,1088583,76.72,3216708
12,2596504,50.35,1117474,76.01,3509136
13,2715338,46.21,1087666,75.32,3801564
14,2861697,42.08,1084692,74.35,4093992
15,2964620,38.02,1087910,73.40,4386420
16,3065575,33.84,1099406,71.07,4678848
17,3107674,29.76,1056948,71.36,4971276
18,3144963,25.71,1094883,70.14,5263704
19,3173468,21.61,1073049,66.21,5556132
20,3173233,17.55,1072417,67.16,5848560
21,3209710,13.37,1079147,65.64,6140988
22,3182958,9.37,1085872,65.95,6433416
23,3200747,5.23,1076414,59.40,6725844
24,3181699,1.04,1051233,65.62,7018272

Page-hinting:
tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,467693,95.83,467970,95.83,467970
2,967860,91.68,895883,91.70,935940
3,1408191,87.53,1279602,87.68,1403910
4,1766250,83.39,1557224,83.93,1871880
5,2124689,79.24,1834625,80.35,2339850
6,2413514,75.10,1989557,77.00,2807820
7,2644648,70.95,2158055,73.73,3275790
8,2896483,66.81,2305785,70.85,3743760
9,3157796,62.67,2304083,69.49,4211730
10,3251633,58.53,2379589,66.43,4679700
11,3313704,54.41,2349310,64.76,5147670
12,3285612,50.30,2362013,62.63,5615640
13,3207275,46.17,2377760,59.94,6083610
14,3221727,42.02,2416278,56.70,6551580
15,3194781,37.91,2334552,54.96,7019550
16,3211818,33.78,2399077,52.75,7487520
17,3172664,29.65,2337660,50.27,7955490
18,3177152,25.49,2349721,47.02,8423460
19,3149924,21.36,2319286,40.16,8891430
20,3166910,17.30,2279719,43.23,9359400
21,3159464,13.19,2342849,34.84,9827370
22,3167091,9.06,2285156,37.97,10295340
23,3174137,4.96,2365448,33.74,10763310
24,3161629,0.86,2253813,32.38,11231280


Test4: Netperf
Guest size: 5GB
Cores: 4
Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
Netserver: Running on core 0
Netperf: Running on core 1
Recv Socket Size bytes: 131072
Send Socket Size bytes:16384
Send Message Size bytes:1000000000
Time: 900s
Process: netperf is run 3 times sequentially in the same guest with the
same inputs mentioned above and throughput (10^6bits/sec) is observed.
unmodified kernel: 1st Run-14769.60, 2nd Run-14849.18, 3rd Run-14842.02
bubble-hinting v1: 1st Run-13441.77, 2nd Run-13487.81, 3rd Run-13503.87
Page-hinting: 1st Run-14308.20, 2nd Run-14344.36, 3rd Run-14450.07

Drawback with bubble-hinting:
More invasive.

Drawback with page-hinting:
Additional bitmap required, including growing/shrinking the bitmap on
memory hotplug.


[1] https://lkml.org/lkml/2019/6/19/926
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


--iJbTV8Ak743uMLzLdbJPIQktYZIfzhuCY--

--rug7ZBWQqUMRKhRW0eh0Qepg46M4EzdPQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl0SNFUACgkQo4ZA3AYy
ozkmQg/9EZRb5GHvw1pASknvxA1cuboT+QuPK5VMl6pXNn13gkYsV2cSEEVTPoCQ
NRvqyRM8XHR1U/Z1xnpR8oRxVw3JAujSFNfMPprWiwc9aq1yGxNI5ivz8sI4LGO+
gVDgBq/u0dJ4i6ovCmIk9VG085d8MEWd1k+hEOngKJOdTPIPKKV3iD7oGT3yblC0
/GUg8Dws9f49hIuuAFqvIy5U3AG+Q0+rvzit9notITAKeUOEhVMbV3+sFDUdIRqy
Mm3jBCjN+81ueu0KLBF66v3WnlnfrhLANjE4IHWPusvjP+6XZxkjCJvsMH1JExpr
7WGgeWSXxKCQBYYt3AHRTACZ4qZC50A51G+U+BwI3g4sarkK6aSXKbEhD8CBv6zd
tgWcMmlMztB6uYQsijnyzhwlgN+BOL/sl5tTVa1b8i+dSV+8UMhipeEYEUPMRbZC
OTCyw81FnAV8ZmzDOAQD7JTsV/aUk3ZYTvFkAiQgFtipqFRB1Bc6YetDpgMUyOvD
keN4jRQA/LJxoCAyZbp3dg1ifQVnJzJB+8fL242rLbxG8rzjHMOg49072ARPhNzx
shLjwA34rS9AjZUrujcafdcAYpqGGi6cDnD3xybF3Wg99588Al9bBlKTYRgArRv7
StyEyCBxTTocopmycV8R3JC2MwIyjO4W0og2QGcxxNGSl+QU1p4=
=bK7P
-----END PGP SIGNATURE-----

--rug7ZBWQqUMRKhRW0eh0Qepg46M4EzdPQ--
