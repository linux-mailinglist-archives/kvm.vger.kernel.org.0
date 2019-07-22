Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1ABF703A9
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfGVPZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 11:25:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34938 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbfGVPZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 11:25:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so35748598wmg.0;
        Mon, 22 Jul 2019 08:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5LxJJzfj24V008N7ss4UH0jDpnObaJiZ7hC/fVauSAg=;
        b=uZ63QAzYVQfTNneRvH9kDLJ/zQ+PXO8USXIkCNdegzE0SbafAOJLRD10X7jKRZjGDi
         iM6DzQ2AoIBEB+Dkyy/tsKc64K2+w2Btjh7bsPiS74ul2EfvxK7URqdX94ZUIJBsovt+
         dml4DX2MbnxeQaC422CtdOcp+91uKmkg8Zk/E8p7c6IwA4jp6yOH+GGoZKdoLH7WJLqM
         6WOayvLnXj4UiCSm2YWsNRZANrIxzCjxUVLXybSjNAmVGEqSVErUqBsmNTED9Q6B+raq
         SEXykC54cSvUqg071w+3jvLxEmdh/gWJafmObu6K0MheCxtoWm7bsCCQ/WVAQ9FzsQIl
         YlEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:openpgp
         :autocrypt:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5LxJJzfj24V008N7ss4UH0jDpnObaJiZ7hC/fVauSAg=;
        b=rmLVtoUSe4UkS6xDDjvEEqLzqqGYs8yIlWGq5QHiPXPDimwrzrO84pHPuzEtWnDwkk
         fjpdvaPaK55Kq9DgHphwmpMlccgNarusi/X6zxzhHkyBMgtt7ukdIPcEvOpnVhet0BXN
         dKITPHx/+qNvdc7PI1nAOTZ//jJjKlrPa72n74J8M6H9QOTTM2P1uB41fh3OyxJe+Fqd
         vy+HFph+hzp9JEgVLYvx81iwKHzySTOQ68hAod66r83rQSaVHcsLmcbrK5nVokTOixg+
         8H+kZNZv623p3ApOaEHwwHLOM/UMdnM4rNFxUYWXFo581hNCOfCMmQ0YeIIfs0Khm9sK
         RTfw==
X-Gm-Message-State: APjAAAXij3s4XXnzbwD3Jgm+ROWZu08nSBPGJFI1flyufaeY2JJVc9/3
        m8LCiPZhycDA3EjZI4uvHd6XIhvNO6g=
X-Google-Smtp-Source: APXvYqznDrL/g3afwneK3sqh5a0JODGxxLyOWrIjKpu2ML70wGNL0+OtvkqdVIouf2r76/X579Ajrg==
X-Received: by 2002:a1c:e109:: with SMTP id y9mr30260981wmg.35.1563809128539;
        Mon, 22 Jul 2019 08:25:28 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.googlemail.com with ESMTPSA id x6sm41602104wrt.63.2019.07.22.08.25.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 08:25:27 -0700 (PDT)
Subject: Re: [patch 0/5] cpuidle haltpoll driver and governor (v6)
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
References: <20190703235124.783034907@amt.cnet>
 <CAJZ5v0jU4MC9j+qWpmZrD86YMS8iKO-m8c94N_MuX1nYrSEmRg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pbonzini@redhat.com; keydata=
 mQHhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAbQj
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT6JAg0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSS5AQ0EVEJxcwEIAK+nUrsUz3aP2aBjIrX3a1+C+39R
 nctpNIPcJjFJ/8WafRiwcEuLjbvJ/4kyM6K7pWUIQftl1P8Woxwb5nqL7zEFHh5I+hKS3haO
 5pgco//V0tWBGMKinjqntpd4U4Dl299dMBZ4rRbPvmI8rr63sCENxTnHhTECyHdGFpqSzWzy
 97rH68uqMpxbUeggVwYkYihZNd8xt1+lf7GWYNEO/QV8ar/qbRPG6PEfiPPHQd/sldGYavmd
 //o6TQLSJsvJyJDt7KxulnNT8Q2X/OdEuVQsRT5glLaSAeVAABcLAEnNgmCIGkX7TnQF8a6w
 gHGrZIR9ZCoKvDxAr7RP6mPeS9sAEQEAAYkDEgQYAQIACQUCVEJxcwIbAgEpCRB+FRAMzTZp
 scBdIAQZAQIABgUCVEJxcwAKCRC/+9JfeMeug/SlCACl7QjRnwHo/VzENWD9G2VpUOd9eRnS
 DZGQmPo6Mp3Wy8vL7snGFBfRseT9BevXBSkxvtOnUUV2YbyLmolAODqUGzUI8ViF339poOYN
 i6Ffek0E19IMQ5+CilqJJ2d5ZvRfaq70LA/Ly9jmIwwX4auvXrWl99/2wCkqnWZI+PAepkcX
 JRD4KY2fsvRi64/aoQmcxTiyyR7q3/52Sqd4EdMfj0niYJV0Xb9nt8G57Dp9v3Ox5JeWZKXS
 krFqy1qyEIypIrqcMbtXM7LSmiQ8aJRM4ZHYbvgjChJKR4PsKNQZQlMWGUJO4nVFSkrixc9R
 Z49uIqQK3b3ENB1QkcdMg9cxsB0Onih8zR+Wp1uDZXnz1ekto+EivLQLqvTjCCwLxxJafwKI
 bqhQ+hGR9jF34EFur5eWt9jJGloEPVv0GgQflQaE+rRGe+3f5ZDgRe5Y/EJVNhBhKcafcbP8
 MzmLRh3UDnYDwaeguYmxuSlMdjFL96YfhRBXs8tUw6SO9jtCgBvoOIBDCxxAJjShY4KIvEpK
 b2hSNr8KxzelKKlSXMtB1bbHbQxiQcerAipYiChUHq1raFc3V0eOyCXK205rLtknJHhM5pfG
 6taABGAMvJgm/MrVILIxvBuERj1FRgcgoXtiBmLEJSb7akcrRlqe3MoPTntSTNvNzAJmfWhd
 SvP0G1WDLolqvX0OtKMppI91AWVu72f1kolJg43wbaKpRJg1GMkKEI3H+jrrlTBrNl/8e20m
 TElPRDKzPiowmXeZqFSS1A6Azv0TJoo9as+lWF+P4zCXt40+Zhh5hdHO38EV7vFAVG3iuay6
 7ToF8Uy7tgc3mdH98WQSmHcn/H5PFYk3xTP3KHB7b0FZPdFPQXBZb9+tJeZBi9gMqcjMch+Y
 R8dmTcQRQX14bm5nXlBF7VpSOPZMR392LY7wzAvRdhz7aeIUkdO7VelaspFk2nT7wOj1Y6uL
 nRxQlLkBDQRUQnHuAQgAx4dxXO6/Zun0eVYOnr5GRl76+2UrAAemVv9Yfn2PbDIbxXqLff7o
 yVJIkw4WdhQIIvvtu5zH24iYjmdfbg8iWpP7NqxUQRUZJEWbx2CRwkMHtOmzQiQ2tSLjKh/c
 HeyFH68xjeLcinR7jXMrHQK+UCEw6jqi1oeZzGvfmxarUmS0uRuffAb589AJW50kkQK9VD/9
 QC2FJISSUDnRC0PawGSZDXhmvITJMdD4TjYrePYhSY4uuIV02v028TVAaYbIhxvDY0hUQE4r
 8ZbGRLn52bEzaIPgl1p/adKfeOUeMReg/CkyzQpmyB1TSk8lDMxQzCYHXAzwnGi8WU9iuE1P
 0wARAQABiQHzBBgBAgAJBQJUQnHuAhsMAAoJEH4VEAzNNmmxp1EOoJy0uZggJm7gZKeJ7iUp
 eX4eqUtqelUw6gU2daz2hE/jsxsTbC/w5piHmk1H1VWDKEM4bQBTuiJ0bfo55SWsUNN+c9hh
 IX+Y8LEe22izK3w7mRpvGcg+/ZRG4DEMHLP6JVsv5GMpoYwYOmHnplOzCXHvmdlW0i6SrMsB
 Dl9rw4AtIa6bRwWLim1lQ6EM3PWifPrWSUPrPcw4OLSwFk0CPqC4HYv/7ZnASVkR5EERFF3+
 6iaaVi5OgBd81F1TCvCX2BEyIDRZLJNvX3TOd5FEN+lIrl26xecz876SvcOb5SL5SKg9/rCB
 ufdPSjojkGFWGziHiFaYhbuI2E+NfWLJtd+ZvWAAV+O0d8vFFSvriy9enJ8kxJwhC0ECbSKF
 Y+W1eTIhMD3aeAKY90drozWEyHhENf4l/V+Ja5vOnW+gCDQkGt2Y1lJAPPSIqZKvHzGShdh8
 DduC0U3xYkfbGAUvbxeepjgzp0uEnBXfPTy09JGpgWbg0w91GyfT/ujKaGd4vxG2Ei+MMNDm
 S1SMx7wu0evvQ5kT9NPzyq8R2GIhVSiAd2jioGuTjX6AZCFv3ToO53DliFMkVTecLptsXaes
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <4482d633-553d-d550-920d-822d9df55b3d@redhat.com>
Date:   Mon, 22 Jul 2019 17:25:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0jU4MC9j+qWpmZrD86YMS8iKO-m8c94N_MuX1nYrSEmRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 10:32, Rafael J. Wysocki wrote:
> On Thu, Jul 4, 2019 at 1:59 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>
>> (rebased against queue branch of kvm.git tree)
>>
>> The cpuidle-haltpoll driver with haltpoll governor allows the guest
>> vcpus to poll for a specified amount of time before halting.
>> This provides the following benefits to host side polling:
>>
>>          1) The POLL flag is set while polling is performed, which allows
>>             a remote vCPU to avoid sending an IPI (and the associated
>>             cost of handling the IPI) when performing a wakeup.
>>
>>          2) The VM-exit cost can be avoided.
>>
>> The downside of guest side polling is that polling is performed
>> even with other runnable tasks in the host.
>>
>> Results comparing halt_poll_ns and server/client application
>> where a small packet is ping-ponged:
>>
>> host                                        --> 31.33
>> halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
>> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
>>
>> For the SAP HANA benchmarks (where idle_spin is a parameter
>> of the previous version of the patch, results should be the
>> same):
>>
>> hpns == halt_poll_ns
>>
>>                            idle_spin=0/   idle_spin=800/    idle_spin=0/
>>                            hpns=200000    hpns=0            hpns=800000
>> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
>> InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
>> DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)      1.29   (-3.7%)
>> UpdateC00T03 (1 thread)   4.72           4.18 (-12%)       4.53   (-5%)
>>
>> V2:
>>
>> - Move from x86 to generic code (Paolo/Christian)
>> - Add auto-tuning logic (Paolo)
>> - Add MSR to disable host side polling (Paolo)
>>
>> V3:
>>
>> - Do not be specific about HLT VM-exit in the documentation (Ankur Arora)
>> - Mark tuning parameters static and __read_mostly (Andrea Arcangeli)
>> - Add WARN_ON if host does not support poll control (Joao Martins)
>> - Use sched_clock and cleanup haltpoll_enter_idle (Peter Zijlstra)
>> - Mark certain functions in kvm.c as static (kernel test robot)
>> - Remove tracepoints as they use RCU from extended quiescent state (kernel
>> test robot)
>>
>> V4:
>> - Use a haltpoll governor, use poll_state.c poll code (Rafael J. Wysocki)
>>
>> V5:
>> - Take latency requirement into consideration (Rafael J. Wysocki)
>> - Set target_residency/exit_latency to 1 (Rafael J. Wysocki)
>> - Do not load cpuidle driver if not virtualized (Rafael J. Wysocki)
>>
>> V6:
>> - Switch from callback to poll_limit_ns variable in cpuidle device structure
>> (Rafael J. Wysocki)
>> - Move last_used_idx to cpuidle device structure (Rafael J. Wysocki)
>> - Drop per-cpu device structure in haltpoll governor (Rafael J. Wysocki)
> 
> It looks good to me now, but I have some cpuidle changes in the work
> that will clash in some changes in this series if not rebased on top
> of it, so IMO it would make sense for me to get patches [1-4/5] at
> least into my queue.  I can expose an immutable branch with them for
> the KVM tree to consume.  I can take the last patch in the series as
> well if I get an ACK for it.
> 
> Would that work for everybody?

Rafael, please take the whole series in your tree.  Thanks!

Paolo
