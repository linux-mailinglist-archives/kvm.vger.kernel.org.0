Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ADD5A382
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 20:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfF1SZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 14:25:54 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:44049 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF1SZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 14:25:53 -0400
Received: by mail-io1-f45.google.com with SMTP id s7so14425501iob.11;
        Fri, 28 Jun 2019 11:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NdjWQOf/yOx5ZW0w8+A5hA2av2WUhbolbuF5akIF1VY=;
        b=r6+g2L5rqKXu/g2S/ETP5H5BKttxzeG1ZI4/XWzYLvYRQV+Zj9x4T0uwmtGvOCGP+5
         tVaRuyUEBs+IAwv3AUvHUkV9KJuitmmge9/AxAuuuPZ5QXRpZxzb9Av8lTTH7i+hNUnl
         seii6jde8L44EbD8745YRip2UWXJcO75TSe4wVh/GE8bjUSnS/pQoZglMROqaRkJiCbG
         NCLjDDpCDqERsEBiyGENkIHlbUDnPLctc16eenGCSzDpO+Q/sWpv7F/y4l78429gZT58
         f+Hqmi+ulRNn96GPWtDS9mdK/xEDSmroi376Jp55zW323JkYbQLJHyi4mFTUUn5aoJ+9
         3LZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NdjWQOf/yOx5ZW0w8+A5hA2av2WUhbolbuF5akIF1VY=;
        b=BtgMAG1+Dcrp0KEj+jhIMBjx/8f9aHuwq8/orV3V5l34DsKT/gZh3vu2VG7EgYGkfh
         XKzHj83OhS4s97ZoTsb8gvfsqLTUWSMR4mVattP8LjFXS7UuK+SFgvsB24WQznrKBaji
         Phujd5dXv2Z1QrwdqtH0LX93v3qqw6y8xnc0ygC6f4lRyOqLEG1YqfcDc08Y3MKZidzJ
         Wkajr8kD3mSHWRu0VbUukVzain07/sMd2fNRcR62Fu6JLTO1gXdWJhDjVSEwA7acbSXo
         r3lRjckYrnbqNHBc62+Lf+1Di++FYnZAa95dNCIpwMZBRClvqXmIFGO+X+PyzA2f+zje
         1hmw==
X-Gm-Message-State: APjAAAX5eu2jyjvrn/Wl36c46XXfOsaOyHZrVNE0LehNt7WtN71ANnV3
        BX+AcBnbpX5Ykhhkyc224ui7msziRZ9+SW1nBm0=
X-Google-Smtp-Source: APXvYqzsCCS7suEEDv1ctetOh+HYaqDjC7aQq+cRFaNaEWH1OHFRfIz+86nsi4xUSxd/kmrgVnuVAXElrYURYb/lrnY=
X-Received: by 2002:a6b:b790:: with SMTP id h138mr11996522iof.64.1561746352253;
 Fri, 28 Jun 2019 11:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603140304-mutt-send-email-mst@kernel.org>
 <afac6f92-74f5-4580-0303-12b7374e5011@redhat.com> <CAKgT0UdK2v+xTwzjLfc69Baz0iDp7GnGRdUacQPue5XHFfQxHg@mail.gmail.com>
 <cc20a6d2-9e95-3de4-301a-f2a6a5b025e4@redhat.com>
In-Reply-To: <cc20a6d2-9e95-3de4-301a-f2a6a5b025e4@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 28 Jun 2019 11:25:41 -0700
Message-ID: <CAKgT0UfMGXQWzS7=UVquCPECEpPZ1DHzmoH9aOz=r-Di=OKFrA@mail.gmail.com>
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 10:32 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> On 6/25/19 1:10 PM, Alexander Duyck wrote:
> > On Tue, Jun 25, 2019 at 7:49 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >>
> >> On 6/3/19 2:04 PM, Michael S. Tsirkin wrote:
> >>> On Mon, Jun 03, 2019 at 01:03:04PM -0400, Nitesh Narayan Lal wrote:
> >>>> This patch series proposes an efficient mechanism for communicating free memory
> >>>> from a guest to its hypervisor. It especially enables guests with no page cache
> >>>> (e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
> >>>> rapidly hand back free memory to the hypervisor.
> >>>> This approach has a minimal impact on the existing core-mm infrastructure.
> >>> Could you help us compare with Alex's series?
> >>> What are the main differences?
> >> Results on comparing the benefits/performance of Alexander's v1
> >> (bubble-hinting)[1], Page-Hinting (includes some of the upstream
> >> suggested changes on v10) over an unmodified Kernel.
> >>
> >> Test1 - Number of guests that can be launched without swap usage.
> >> Guest size: 5GB
> >> Cores: 4
> >> Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
> >> Process: Guest is launched sequentially after running an allocation
> >> program with 4GB request.
> >>
> >> Results:
> >> unmodified kernel: 2 guests without swap usage and 3rd guest with a swap
> >> usage of 2.3GB.
> >> bubble-hinting v1: 4 guests without swap usage and 5th guest with a swap
> >> usage of 1MB.
> >> Page-hinting: 5 guests without swap usage and 6th guest with a swap
> >> usage of 8MB.
> >>
> >>
> >> Test2 - Memhog execution time
> >> Guest size: 6GB
> >> Cores: 4
> >> Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
> >> Process: 3 guests are launched and "time memhog 6G" is launched in each
> >> of them sequentially.
> >>
> >> Results:
> >> unmodified kernel: Guest1-40s, Guest2-1m5s, Guest3-6m38s (swap usage at
> >> the end-3.6G)
> >> bubble-hinting v1: Guest1-32s, Guest2-58s, Guest3-35s (swap usage at the
> >> end-0)
> >> Page-hinting: Guest1-42s, Guest2-47s, Guest3-32s (swap usage at the end-0)
> >>
> >>
> >> Test3 - Will-it-scale's page_fault1
> >> Guest size: 6GB
> >> Cores: 24
> >> Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
> >>
> >> unmodified kernel:
> >> tasks,processes,processes_idle,threads,threads_idle,linear
> >> 0,0,100,0,100,0
> >> 1,459168,95.83,459315,95.83,459315
> >> 2,956272,91.68,884643,91.72,918630
> >> 3,1407811,87.53,1267948,87.69,1377945
> >> 4,1755744,83.39,1562471,83.73,1837260
> >> 5,2056741,79.24,1812309,80.00,2296575
> >> 6,2393759,75.09,2025719,77.02,2755890
> >> 7,2754403,70.95,2238180,73.72,3215205
> >> 8,2947493,66.81,2369686,70.37,3674520
> >> 9,3063579,62.68,2321148,68.84,4133835
> >> 10,3229023,58.54,2377596,65.84,4593150
> >> 11,3337665,54.40,2429818,64.01,5052465
> >> 12,3255140,50.28,2395070,61.63,5511780
> >> 13,3260721,46.11,2402644,59.77,5971095
> >> 14,3210590,42.02,2390806,57.46,6430410
> >> 15,3164811,37.88,2265352,51.39,6889725
> >> 16,3144764,33.77,2335028,54.07,7349040
> >> 17,3128839,29.63,2328662,49.52,7808355
> >> 18,3133344,25.50,2301181,48.01,8267670
> >> 19,3135979,21.38,2343003,43.66,8726985
> >> 20,3136448,17.27,2306109,40.81,9186300
> >> 21,3130324,13.16,2403688,35.84,9645615
> >> 22,3109883,9.04,2290808,36.24,10104930
> >> 23,3136805,4.94,2263818,35.43,10564245
> >> 24,3118949,0.78,2252891,31.03,11023560
> >>
> >> bubble-hinting v1:
> >> tasks,processes,processes_idle,threads,threads_idle,linear
> >> 0,0,100,0,100,0
> >> 1,292183,95.83,292428,95.83,292428
> >> 2,540606,91.67,501887,91.91,584856
> >> 3,821748,87.53,735244,88.31,877284
> >> 4,1033782,83.38,839925,85.59,1169712
> >> 5,1261352,79.25,896464,83.86,1462140
> >> 6,1459544,75.12,1050094,80.93,1754568
> >> 7,1686537,70.97,1112202,79.23,2046996
> >> 8,1866892,66.83,1083571,78.48,2339424
> >> 9,2056887,62.72,1101660,77.94,2631852
> >> 10,2252955,58.57,1097439,77.36,2924280
> >> 11,2413907,54.40,1088583,76.72,3216708
> >> 12,2596504,50.35,1117474,76.01,3509136
> >> 13,2715338,46.21,1087666,75.32,3801564
> >> 14,2861697,42.08,1084692,74.35,4093992
> >> 15,2964620,38.02,1087910,73.40,4386420
> >> 16,3065575,33.84,1099406,71.07,4678848
> >> 17,3107674,29.76,1056948,71.36,4971276
> >> 18,3144963,25.71,1094883,70.14,5263704
> >> 19,3173468,21.61,1073049,66.21,5556132
> >> 20,3173233,17.55,1072417,67.16,5848560
> >> 21,3209710,13.37,1079147,65.64,6140988
> >> 22,3182958,9.37,1085872,65.95,6433416
> >> 23,3200747,5.23,1076414,59.40,6725844
> >> 24,3181699,1.04,1051233,65.62,7018272
> >>
> >> Page-hinting:
> >> tasks,processes,processes_idle,threads,threads_idle,linear
> >> 0,0,100,0,100,0
> >> 1,467693,95.83,467970,95.83,467970
> >> 2,967860,91.68,895883,91.70,935940
> >> 3,1408191,87.53,1279602,87.68,1403910
> >> 4,1766250,83.39,1557224,83.93,1871880
> >> 5,2124689,79.24,1834625,80.35,2339850
> >> 6,2413514,75.10,1989557,77.00,2807820
> >> 7,2644648,70.95,2158055,73.73,3275790
> >> 8,2896483,66.81,2305785,70.85,3743760
> >> 9,3157796,62.67,2304083,69.49,4211730
> >> 10,3251633,58.53,2379589,66.43,4679700
> >> 11,3313704,54.41,2349310,64.76,5147670
> >> 12,3285612,50.30,2362013,62.63,5615640
> >> 13,3207275,46.17,2377760,59.94,6083610
> >> 14,3221727,42.02,2416278,56.70,6551580
> >> 15,3194781,37.91,2334552,54.96,7019550
> >> 16,3211818,33.78,2399077,52.75,7487520
> >> 17,3172664,29.65,2337660,50.27,7955490
> >> 18,3177152,25.49,2349721,47.02,8423460
> >> 19,3149924,21.36,2319286,40.16,8891430
> >> 20,3166910,17.30,2279719,43.23,9359400
> >> 21,3159464,13.19,2342849,34.84,9827370
> >> 22,3167091,9.06,2285156,37.97,10295340
> >> 23,3174137,4.96,2365448,33.74,10763310
> >> 24,3161629,0.86,2253813,32.38,11231280
> >>
> >>
> >> Test4: Netperf
> >> Guest size: 5GB
> >> Cores: 4
> >> Total NUMA Node Memory ~ 15 GB (All guests are running on a single node)
> >> Netserver: Running on core 0
> >> Netperf: Running on core 1
> >> Recv Socket Size bytes: 131072
> >> Send Socket Size bytes:16384
> >> Send Message Size bytes:1000000000
> >> Time: 900s
> >> Process: netperf is run 3 times sequentially in the same guest with the
> >> same inputs mentioned above and throughput (10^6bits/sec) is observed.
> >> unmodified kernel: 1st Run-14769.60, 2nd Run-14849.18, 3rd Run-14842.02
> >> bubble-hinting v1: 1st Run-13441.77, 2nd Run-13487.81, 3rd Run-13503.87
> >> Page-hinting: 1st Run-14308.20, 2nd Run-14344.36, 3rd Run-14450.07
> >>
> >> Drawback with bubble-hinting:
> >> More invasive.
> >>
> >> Drawback with page-hinting:
> >> Additional bitmap required, including growing/shrinking the bitmap on
> >> memory hotplug.
> >>
> >>
> >> [1] https://lkml.org/lkml/2019/6/19/926
> > Any chance you could provide a .config for your kernel? I'm wondering
> > what is different between the two as it seems like you are showing a
> > significant regression in terms of performance for the bubble
> > hinting/aeration approach versus a stock kernel without the patches
> > and that doesn't match up with what I have been seeing.
> I have attached the config which I was using.

Were all of these runs with the same config? I ask because I noticed
the config you provided had a number of quite expensive memory debug
options enabled:

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

When I went through and enabled these then my results for the bubble
hinting matched pretty closely to what you reported. However, when I
compiled without the patches and this config enabled the results were
still about what was reported with the bubble hinting but were maybe
5% improved. I'm just wondering if you were doing some additional
debugging and left those options enabled for the bubble hinting test
run.
