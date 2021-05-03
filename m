Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD96371903
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhECQQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 12:16:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:31300 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230518AbhECQQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 12:16:30 -0400
IronPort-SDR: hp9WlzW06AqiaJusbrtqXc4m1e7xHUNTXBiIyawqAPYSRiXLzMqpqkOWORFIKmtZNV1OOq+sng
 sdWYU4hGHItQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="261727945"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="261727945"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 09:15:36 -0700
IronPort-SDR: StB7GiTTNzFCYycrJg+0OT5VWV47QPiU2cytvBz883/6hsMebQHSImV5vXrugMvRN35TYvzZ1R
 L+wuVJCC6M5A==
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="432815036"
Received: from tbroiles-mobl.amr.corp.intel.com (HELO [10.209.47.222]) ([10.209.47.222])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 09:15:36 -0700
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
 <d25db3c9-86ba-b72f-dab7-1dde49bc1229@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzShEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gPGRhdmVAc3I3MS5uZXQ+wsF7BBMBAgAlAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAUCTo3k0QIZAQAKCRBoNZUwcMmSsMO2D/421Xg8pimb9mPzM5N7khT0
 2MCnaGssU1T59YPE25kYdx2HntwdO0JA27Wn9xx5zYijOe6B21ufrvsyv42auCO85+oFJWfE
 K2R/IpLle09GDx5tcEmMAHX6KSxpHmGuJmUPibHVbfep2aCh9lKaDqQR07gXXWK5/yU1Dx0r
 VVFRaHTasp9fZ9AmY4K9/BSA3VkQ8v3OrxNty3OdsrmTTzO91YszpdbjjEFZK53zXy6tUD2d
 e1i0kBBS6NLAAsqEtneplz88T/v7MpLmpY30N9gQU3QyRC50jJ7LU9RazMjUQY1WohVsR56d
 ORqFxS8ChhyJs7BI34vQusYHDTp6PnZHUppb9WIzjeWlC7Jc8lSBDlEWodmqQQgp5+6AfhTD
 kDv1a+W5+ncq+Uo63WHRiCPuyt4di4/0zo28RVcjtzlGBZtmz2EIC3vUfmoZbO/Gn6EKbYAn
 rzz3iU/JWV8DwQ+sZSGu0HmvYMt6t5SmqWQo/hyHtA7uF5Wxtu1lCgolSQw4t49ZuOyOnQi5
 f8R3nE7lpVCSF1TT+h8kMvFPv3VG7KunyjHr3sEptYxQs4VRxqeirSuyBv1TyxT+LdTm6j4a
 mulOWf+YtFRAgIYyyN5YOepDEBv4LUM8Tz98lZiNMlFyRMNrsLV6Pv6SxhrMxbT6TNVS5D+6
 UorTLotDZKp5+M7BTQRUY85qARAAsgMW71BIXRgxjYNCYQ3Xs8k3TfAvQRbHccky50h99TUY
 sqdULbsb3KhmY29raw1bgmyM0a4DGS1YKN7qazCDsdQlxIJp9t2YYdBKXVRzPCCsfWe1dK/q
 66UVhRPP8EGZ4CmFYuPTxqGY+dGRInxCeap/xzbKdvmPm01Iw3YFjAE4PQ4hTMr/H76KoDbD
 cq62U50oKC83ca/PRRh2QqEqACvIH4BR7jueAZSPEDnzwxvVgzyeuhwqHY05QRK/wsKuhq7s
 UuYtmN92Fasbxbw2tbVLZfoidklikvZAmotg0dwcFTjSRGEg0Gr3p/xBzJWNavFZZ95Rj7Et
 db0lCt0HDSY5q4GMR+SrFbH+jzUY/ZqfGdZCBqo0cdPPp58krVgtIGR+ja2Mkva6ah94/oQN
 lnCOw3udS+Eb/aRcM6detZr7XOngvxsWolBrhwTQFT9D2NH6ryAuvKd6yyAFt3/e7r+HHtkU
 kOy27D7IpjngqP+b4EumELI/NxPgIqT69PQmo9IZaI/oRaKorYnDaZrMXViqDrFdD37XELwQ
 gmLoSm2VfbOYY7fap/AhPOgOYOSqg3/Nxcapv71yoBzRRxOc4FxmZ65mn+q3rEM27yRztBW9
 AnCKIc66T2i92HqXCw6AgoBJRjBkI3QnEkPgohQkZdAb8o9WGVKpfmZKbYBo4pEAEQEAAcLB
 XwQYAQIACQUCVGPOagIbDAAKCRBoNZUwcMmSsJeCEACCh7P/aaOLKWQxcnw47p4phIVR6pVL
 e4IEdR7Jf7ZL00s3vKSNT+nRqdl1ugJx9Ymsp8kXKMk9GSfmZpuMQB9c6io1qZc6nW/3TtvK
 pNGz7KPPtaDzvKA4S5tfrWPnDr7n15AU5vsIZvgMjU42gkbemkjJwP0B1RkifIK60yQqAAlT
 YZ14P0dIPdIPIlfEPiAWcg5BtLQU4Wg3cNQdpWrCJ1E3m/RIlXy/2Y3YOVVohfSy+4kvvYU3
 lXUdPb04UPw4VWwjcVZPg7cgR7Izion61bGHqVqURgSALt2yvHl7cr68NYoFkzbNsGsye9ft
 M9ozM23JSgMkRylPSXTeh5JIK9pz2+etco3AfLCKtaRVysjvpysukmWMTrx8QnI5Nn5MOlJj
 1Ov4/50JY9pXzgIDVSrgy6LYSMc4vKZ3QfCY7ipLRORyalFDF3j5AGCMRENJjHPD6O7bl3Xo
 4DzMID+8eucbXxKiNEbs21IqBZbbKdY1GkcEGTE7AnkA3Y6YB7I/j9mQ3hCgm5muJuhM/2Fr
 OPsw5tV/LmQ5GXH0JQ/TZXWygyRFyyI2FqNTx4WHqUn3yFj8rwTAU1tluRUYyeLy0ayUlKBH
 ybj0N71vWO936MqP6haFERzuPAIpxj2ezwu0xb1GjTk4ynna6h5GjnKgdfOWoRtoWndMZxbA
 z5cecg==
Message-ID: <8764e6f0-4a2e-4eea-af69-62ff3ddfe84b@intel.com>
Date:   Mon, 3 May 2021 09:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d25db3c9-86ba-b72f-dab7-1dde49bc1229@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/21 8:37 AM, Brijesh Singh wrote:
> GHCB was just an example. Another example is a vfio driver accessing the
> shared page. If those pages are not marked shared then kernel access
> will cause an RMP fault. Ideally we should not be running into this
> situation, but if we do, then I am trying to see how best we can avoid
> the host crashes.

I'm confused.  Are you suggesting that the VFIO driver could be passed
an address such that the host kernel would blindly try to write private
guest memory?

The host kernel *knows* which memory is guest private and what is
shared.  It had to set it up in the first place.  It can also consult
the RMP at any time if it somehow forgot.

So, this scenario seems to be that the host got a guest physical address
(gpa) from the guest, it did a gpa->hpa->hva conversion and then wrote
the page all without bothering to consult the RMP.  Shouldn't the the
gpa->hpa conversion point offer a perfect place to determine if the page
is shared or private?

> Another reason for having this is to catch  the hypervisor bug, during
> the SNP guest create, the KVM allocates few backing pages and sets the
> assigned bit for it (the examples are VMSA, and firmware context page).
> If hypervisor accidentally free's these pages without clearing the
> assigned bit in the RMP table then it will result in RMP fault and thus
> a kernel crash.

I think I'd be just fine with a BUG_ON() in those cases instead of an
attempt to paper over the issue.  Kernel crashes are fine in the case of
kernel bugs.

>> Or, worst case, you could use exception tables and something like
>> copy_to_user() to write to the GHCB.  That way, the thread doing the
>> write can safely recover from the fault without the instruction actually
>> ever finishing execution.
>>
>> BTW, I went looking through the spec.  I didn't see anything about the
>> guest being able to write the "Assigned" RMP bit.  Did I miss that?
>> Which of the above three conditions is triggered by the guest failing to
>> make the GHCB page shared?
> 
> The GHCB spec section "Page State Change" provides an interface for the
> guest to request the page state change. During bootup, the guest uses
> the Page State Change VMGEXIT to request hypervisor to make the page
> shared. The hypervisor uses the RMPUPDATE instruction to write to
> "assigned" bit in the RMP table.

Right...  So the *HOST* is in control.  Why should the host ever be
surprised by a page transitioning from shared to private?

> On VMGEXIT, the very first thing which vmgexit handler does is to map
> the GHCB page for the access and then later using the copy_to_user() to
> sync the GHCB updates from hypervisor to guest. The copy_to_user() will
> cause a RMP fault if the GHCB is not mapped shared. As I explained
> above, GHCB page was just an example, vfio or other may also get into
> this situation.

Causing an RMP fault is fine.  The problem is shoving a whole bunch of
*recovery* code in the kernel when recovery isn't necessary.  Just look
for the -EFAULT from copy_to_user() and move on with life.
