Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AF85A4F7
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 21:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfF1TOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 15:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 15:14:46 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 570DF81F2F;
        Fri, 28 Jun 2019 19:14:40 +0000 (UTC)
Received: from [10.40.204.22] (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A352C19C59;
        Fri, 28 Jun 2019 19:13:37 +0000 (UTC)
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603140304-mutt-send-email-mst@kernel.org>
 <afac6f92-74f5-4580-0303-12b7374e5011@redhat.com>
 <CAKgT0UdK2v+xTwzjLfc69Baz0iDp7GnGRdUacQPue5XHFfQxHg@mail.gmail.com>
 <cc20a6d2-9e95-3de4-301a-f2a6a5b025e4@redhat.com>
 <CAKgT0UfMGXQWzS7=UVquCPECEpPZ1DHzmoH9aOz=r-Di=OKFrA@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <99820c01-9016-7262-af11-cd789d10f8e7@redhat.com>
Date:   Fri, 28 Jun 2019 15:13:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfMGXQWzS7=UVquCPECEpPZ1DHzmoH9aOz=r-Di=OKFrA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lU1JB5kvQbpQdsyUzj5WhTdhSNfcmr6CO"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 28 Jun 2019 19:14:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lU1JB5kvQbpQdsyUzj5WhTdhSNfcmr6CO
Content-Type: multipart/mixed; boundary="HhRpdBCks84lltSvMQMBSOmQhDS5tB8BY";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm list <kvm@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
 pagupta@redhat.com, wei.w.wang@intel.com,
 Yang Zhang <yang.zhang.wz@gmail.com>, Rik van Riel <riel@surriel.com>,
 David Hildenbrand <david@redhat.com>, dodgen@google.com,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, dhildenb@redhat.com,
 Andrea Arcangeli <aarcange@redhat.com>
Message-ID: <99820c01-9016-7262-af11-cd789d10f8e7@redhat.com>
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603140304-mutt-send-email-mst@kernel.org>
 <afac6f92-74f5-4580-0303-12b7374e5011@redhat.com>
 <CAKgT0UdK2v+xTwzjLfc69Baz0iDp7GnGRdUacQPue5XHFfQxHg@mail.gmail.com>
 <cc20a6d2-9e95-3de4-301a-f2a6a5b025e4@redhat.com>
 <CAKgT0UfMGXQWzS7=UVquCPECEpPZ1DHzmoH9aOz=r-Di=OKFrA@mail.gmail.com>
In-Reply-To: <CAKgT0UfMGXQWzS7=UVquCPECEpPZ1DHzmoH9aOz=r-Di=OKFrA@mail.gmail.com>

--HhRpdBCks84lltSvMQMBSOmQhDS5tB8BY
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/28/19 2:25 PM, Alexander Duyck wrote:
> On Tue, Jun 25, 2019 at 10:32 AM Nitesh Narayan Lal <nitesh@redhat.com>=
 wrote:
>> On 6/25/19 1:10 PM, Alexander Duyck wrote:
>>> On Tue, Jun 25, 2019 at 7:49 AM Nitesh Narayan Lal <nitesh@redhat.com=
> wrote:
>>>> On 6/3/19 2:04 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Jun 03, 2019 at 01:03:04PM -0400, Nitesh Narayan Lal wrote:=

>>>>>> This patch series proposes an efficient mechanism for communicatin=
g free memory
>>>>>> from a guest to its hypervisor. It especially enables guests with =
no page cache
>>>>>> (e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram >=
 disk) to
>>>>>> rapidly hand back free memory to the hypervisor.
>>>>>> This approach has a minimal impact on the existing core-mm infrast=
ructure.
>>>>> Could you help us compare with Alex's series?
>>>>> What are the main differences?
>>>> Results on comparing the benefits/performance of Alexander's v1
>>>> (bubble-hinting)[1], Page-Hinting (includes some of the upstream
>>>> suggested changes on v10) over an unmodified Kernel.
>>>>
>>>> Test1 - Number of guests that can be launched without swap usage.
>>>> Guest size: 5GB
>>>> Cores: 4
>>>> Total NUMA Node Memory ~ 15 GB (All guests are running on a single n=
ode)
>>>> Process: Guest is launched sequentially after running an allocation
>>>> program with 4GB request.
>>>>
>>>> Results:
>>>> unmodified kernel: 2 guests without swap usage and 3rd guest with a =
swap
>>>> usage of 2.3GB.
>>>> bubble-hinting v1: 4 guests without swap usage and 5th guest with a =
swap
>>>> usage of 1MB.
>>>> Page-hinting: 5 guests without swap usage and 6th guest with a swap
>>>> usage of 8MB.
>>>>
>>>>
>>>> Test2 - Memhog execution time
>>>> Guest size: 6GB
>>>> Cores: 4
>>>> Total NUMA Node Memory ~ 15 GB (All guests are running on a single n=
ode)
>>>> Process: 3 guests are launched and "time memhog 6G" is launched in e=
ach
>>>> of them sequentially.
>>>>
>>>> Results:
>>>> unmodified kernel: Guest1-40s, Guest2-1m5s, Guest3-6m38s (swap usage=
 at
>>>> the end-3.6G)
>>>> bubble-hinting v1: Guest1-32s, Guest2-58s, Guest3-35s (swap usage at=
 the
>>>> end-0)
>>>> Page-hinting: Guest1-42s, Guest2-47s, Guest3-32s (swap usage at the =
end-0)
>>>>
>>>>
>>>> Test3 - Will-it-scale's page_fault1
>>>> Guest size: 6GB
>>>> Cores: 24
>>>> Total NUMA Node Memory ~ 15 GB (All guests are running on a single n=
ode)
>>>>
>>>> unmodified kernel:
>>>> tasks,processes,processes_idle,threads,threads_idle,linear
>>>> 0,0,100,0,100,0
>>>> 1,459168,95.83,459315,95.83,459315
>>>> 2,956272,91.68,884643,91.72,918630
>>>> 3,1407811,87.53,1267948,87.69,1377945
>>>> 4,1755744,83.39,1562471,83.73,1837260
>>>> 5,2056741,79.24,1812309,80.00,2296575
>>>> 6,2393759,75.09,2025719,77.02,2755890
>>>> 7,2754403,70.95,2238180,73.72,3215205
>>>> 8,2947493,66.81,2369686,70.37,3674520
>>>> 9,3063579,62.68,2321148,68.84,4133835
>>>> 10,3229023,58.54,2377596,65.84,4593150
>>>> 11,3337665,54.40,2429818,64.01,5052465
>>>> 12,3255140,50.28,2395070,61.63,5511780
>>>> 13,3260721,46.11,2402644,59.77,5971095
>>>> 14,3210590,42.02,2390806,57.46,6430410
>>>> 15,3164811,37.88,2265352,51.39,6889725
>>>> 16,3144764,33.77,2335028,54.07,7349040
>>>> 17,3128839,29.63,2328662,49.52,7808355
>>>> 18,3133344,25.50,2301181,48.01,8267670
>>>> 19,3135979,21.38,2343003,43.66,8726985
>>>> 20,3136448,17.27,2306109,40.81,9186300
>>>> 21,3130324,13.16,2403688,35.84,9645615
>>>> 22,3109883,9.04,2290808,36.24,10104930
>>>> 23,3136805,4.94,2263818,35.43,10564245
>>>> 24,3118949,0.78,2252891,31.03,11023560
>>>>
>>>> bubble-hinting v1:
>>>> tasks,processes,processes_idle,threads,threads_idle,linear
>>>> 0,0,100,0,100,0
>>>> 1,292183,95.83,292428,95.83,292428
>>>> 2,540606,91.67,501887,91.91,584856
>>>> 3,821748,87.53,735244,88.31,877284
>>>> 4,1033782,83.38,839925,85.59,1169712
>>>> 5,1261352,79.25,896464,83.86,1462140
>>>> 6,1459544,75.12,1050094,80.93,1754568
>>>> 7,1686537,70.97,1112202,79.23,2046996
>>>> 8,1866892,66.83,1083571,78.48,2339424
>>>> 9,2056887,62.72,1101660,77.94,2631852
>>>> 10,2252955,58.57,1097439,77.36,2924280
>>>> 11,2413907,54.40,1088583,76.72,3216708
>>>> 12,2596504,50.35,1117474,76.01,3509136
>>>> 13,2715338,46.21,1087666,75.32,3801564
>>>> 14,2861697,42.08,1084692,74.35,4093992
>>>> 15,2964620,38.02,1087910,73.40,4386420
>>>> 16,3065575,33.84,1099406,71.07,4678848
>>>> 17,3107674,29.76,1056948,71.36,4971276
>>>> 18,3144963,25.71,1094883,70.14,5263704
>>>> 19,3173468,21.61,1073049,66.21,5556132
>>>> 20,3173233,17.55,1072417,67.16,5848560
>>>> 21,3209710,13.37,1079147,65.64,6140988
>>>> 22,3182958,9.37,1085872,65.95,6433416
>>>> 23,3200747,5.23,1076414,59.40,6725844
>>>> 24,3181699,1.04,1051233,65.62,7018272
>>>>
>>>> Page-hinting:
>>>> tasks,processes,processes_idle,threads,threads_idle,linear
>>>> 0,0,100,0,100,0
>>>> 1,467693,95.83,467970,95.83,467970
>>>> 2,967860,91.68,895883,91.70,935940
>>>> 3,1408191,87.53,1279602,87.68,1403910
>>>> 4,1766250,83.39,1557224,83.93,1871880
>>>> 5,2124689,79.24,1834625,80.35,2339850
>>>> 6,2413514,75.10,1989557,77.00,2807820
>>>> 7,2644648,70.95,2158055,73.73,3275790
>>>> 8,2896483,66.81,2305785,70.85,3743760
>>>> 9,3157796,62.67,2304083,69.49,4211730
>>>> 10,3251633,58.53,2379589,66.43,4679700
>>>> 11,3313704,54.41,2349310,64.76,5147670
>>>> 12,3285612,50.30,2362013,62.63,5615640
>>>> 13,3207275,46.17,2377760,59.94,6083610
>>>> 14,3221727,42.02,2416278,56.70,6551580
>>>> 15,3194781,37.91,2334552,54.96,7019550
>>>> 16,3211818,33.78,2399077,52.75,7487520
>>>> 17,3172664,29.65,2337660,50.27,7955490
>>>> 18,3177152,25.49,2349721,47.02,8423460
>>>> 19,3149924,21.36,2319286,40.16,8891430
>>>> 20,3166910,17.30,2279719,43.23,9359400
>>>> 21,3159464,13.19,2342849,34.84,9827370
>>>> 22,3167091,9.06,2285156,37.97,10295340
>>>> 23,3174137,4.96,2365448,33.74,10763310
>>>> 24,3161629,0.86,2253813,32.38,11231280
>>>>
>>>>
>>>> Test4: Netperf
>>>> Guest size: 5GB
>>>> Cores: 4
>>>> Total NUMA Node Memory ~ 15 GB (All guests are running on a single n=
ode)
>>>> Netserver: Running on core 0
>>>> Netperf: Running on core 1
>>>> Recv Socket Size bytes: 131072
>>>> Send Socket Size bytes:16384
>>>> Send Message Size bytes:1000000000
>>>> Time: 900s
>>>> Process: netperf is run 3 times sequentially in the same guest with =
the
>>>> same inputs mentioned above and throughput (10^6bits/sec) is observe=
d.
>>>> unmodified kernel: 1st Run-14769.60, 2nd Run-14849.18, 3rd Run-14842=
=2E02
>>>> bubble-hinting v1: 1st Run-13441.77, 2nd Run-13487.81, 3rd Run-13503=
=2E87
>>>> Page-hinting: 1st Run-14308.20, 2nd Run-14344.36, 3rd Run-14450.07
>>>>
>>>> Drawback with bubble-hinting:
>>>> More invasive.
>>>>
>>>> Drawback with page-hinting:
>>>> Additional bitmap required, including growing/shrinking the bitmap o=
n
>>>> memory hotplug.
>>>>
>>>>
>>>> [1] https://lkml.org/lkml/2019/6/19/926
>>> Any chance you could provide a .config for your kernel? I'm wondering=

>>> what is different between the two as it seems like you are showing a
>>> significant regression in terms of performance for the bubble
>>> hinting/aeration approach versus a stock kernel without the patches
>>> and that doesn't match up with what I have been seeing.
>> I have attached the config which I was using.
> Were all of these runs with the same config? I ask because I noticed
> the config you provided had a number of quite expensive memory debug
> options enabled:
Yes, memory debugging configs were enabled for all the cases.
>
> #
> # Memory Debugging
> #
> CONFIG_PAGE_EXTENSION=3Dy
> CONFIG_DEBUG_PAGEALLOC=3Dy
> CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=3Dy
> CONFIG_PAGE_OWNER=3Dy
> # CONFIG_PAGE_POISONING is not set
> CONFIG_DEBUG_PAGE_REF=3Dy
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DEBUG_OBJECTS=3Dy
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> # CONFIG_DEBUG_OBJECTS_FREE is not set
> # CONFIG_DEBUG_OBJECTS_TIMERS is not set
> # CONFIG_DEBUG_OBJECTS_WORK is not set
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> # CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=3D1
> CONFIG_SLUB_DEBUG_ON=3Dy
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=3Dy
> CONFIG_DEBUG_KMEMLEAK=3Dy
> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=3D400
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=3Dy
> CONFIG_DEBUG_STACK_USAGE=3Dy
> CONFIG_DEBUG_VM=3Dy
> # CONFIG_DEBUG_VM_VMACACHE is not set
> # CONFIG_DEBUG_VM_RB is not set
> # CONFIG_DEBUG_VM_PGFLAGS is not set
> CONFIG_ARCH_HAS_DEBUG_VIRTUAL=3Dy
> CONFIG_DEBUG_VIRTUAL=3Dy
> CONFIG_DEBUG_MEMORY_INIT=3Dy
> CONFIG_DEBUG_PER_CPU_MAPS=3Dy
> CONFIG_HAVE_ARCH_KASAN=3Dy
> CONFIG_CC_HAS_KASAN_GENERIC=3Dy
> # CONFIG_KASAN is not set
> CONFIG_KASAN_STACK=3D1
> # end of Memory Debugging
>
> When I went through and enabled these then my results for the bubble
> hinting matched pretty closely to what you reported. However, when I
> compiled without the patches and this config enabled the results were
> still about what was reported with the bubble hinting but were maybe
> 5% improved. I'm just wondering if you were doing some additional
> debugging and left those options enabled for the bubble hinting test
> run.
I have the same set of debugging options enabled for all three cases
reported.
--=20
Thanks
Nitesh


--HhRpdBCks84lltSvMQMBSOmQhDS5tB8BY--

--lU1JB5kvQbpQdsyUzj5WhTdhSNfcmr6CO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl0WZsUACgkQo4ZA3AYy
ozm7mBAAnIAAbdeZafZYiHazscBaLkB/JTCJ9I0m/pKncHlLFElzKzOwr/Kh8fp2
RaNBIjTX8ccerjdGR9UsAb/87xmCrDhp+hpA+A//frFEBZh5bD6zHy00BsqHX9vM
CubZsLPSmskIR3r8x0TbRBiZJ94fHbj2NPJRaU7AZopxnmuGPdiM6m/3Pw17UhXa
O6QsDNtxesfu5F18+BaNTe+LU1ly738C6xTkDlyTiPwnfixHxoP7oFPre8H0SgCA
IHY1PSYFryUEVoSyzDD4BN96rCLhwxwnPbid2MrvHu1ahIbFNSP/OnhHEHw0Cnil
QKSSyCq4vjftLP0R7wlq+VwnUZ0XoF5R/gLMEv0mbTQtbqSwWscSClvPcnedJbh7
lPx9O2HPAe12Ge0xFeZUBqBbio2Wr5u6k4i4mIZZLdL/qEb0w0p3l1aei02qRrlD
i96vfMnga/oxKloqEZZfZPNroWhOowsc8RztkKK9FXAsauEIcT0EmtmJs1UKrEDb
yhaKcKtjcA8uw8gINwXoQTVeIel0TMWGyU0izO9gcAUmn6hW1fiHj0GmTfmVbOXS
jrhMyO7B293jQq2DHH4TRd/YLNaW2qtOsAJn3ME/QfkMME+WsIhXulK4W35z3ZoB
833u1NXVHeMk/qEXBbWEk7OD4Qdngo3PiX3gvOk6vBB15X4TPCQ=
=CLM+
-----END PGP SIGNATURE-----

--lU1JB5kvQbpQdsyUzj5WhTdhSNfcmr6CO--
