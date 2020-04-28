Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C887D1BC573
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgD1Qlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:41:49 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:41896 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgD1Qlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:41:49 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2020 12:41:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1588092108;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0w6FX0efDJGzaehxYFThqDcH+QYQY0rUFheCeGs7Cu8=;
  b=YhBFFxiGRIw+sJcxA0K3Xy3AoZzcgqu/Rgty6fE0TH7GVISc1Xc+Vnqc
   uzTvZfxgfweUGMsL8U/QRVySvItNRqOFvB6ynEKOarIUc05xqdK4+BP0p
   SUShCtjE/P3i07nS0IGA3ViLhWl1EcQshfOlFR6VlbBJu4roCN3um8YJ9
   E=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa1.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: GfTE0zwlZX/DF1ctKDqrxqeVbE8WVcfOvsjN98osQHnlIj+bOA/2LFcYVb0aH7461lKjAVAfLx
 7j15tUKm7Q9jukDiXGBXe4JArojeffWncpdbJdc8J++Ucn0eFvbBbxBJWeB9VAlVhEsRfeADRX
 IWdKBPAe2bZuNVhHpQqKaPx3D4feKv58+vQM9FlmpNzLI+AL1Z6D6MtcVx42gwF/6YidSiYLvI
 o3l7R+GG2CLL3cZaUut58uQQSlPrgZH5ynhcWk//W7GtWbcIlSDiJOv63nzSwdEOcFOfFhx9DW
 9eM=
X-SBRS: 2.7
X-MesageID: 16638438
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.73,328,1583211600"; 
   d="scan'208";a="16638438"
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
To:     Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>
CC:     Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Tom Lendacky" <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Juergen Gross" <JGross@suse.com>, Jiri Slaby <jslaby@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Thomas Hellstrom" <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <1b232a8e-af99-4f7b-05c5-584b82853ac5@citrix.com>
Date:   Tue, 28 Apr 2020 17:34:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428075512.GP30814@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/2020 08:55, Joerg Roedel wrote:
> On Mon, Apr 27, 2020 at 10:37:41AM -0700, Andy Lutomirski wrote:
>> I have a somewhat serious question: should we use IST for #VC at all?
>> As I understand it, Rome and Naples make it mandatory for hypervisors
>> to intercept #DB, which means that, due to the MOV SS mess, it's sort
>> of mandatory to use IST for #VC.  But Milan fixes the #DB issue, so,
>> if we're running under a sufficiently sensible hypervisor, we don't
>> need IST for #VC.
> The reason for #VC being IST is not only #DB, but also SEV-SNP. SNP adds
> page ownership tracking between guest and host, so that the hypervisor
> can't remap guest pages without the guest noticing.
>
> If there is a violation of ownership, which can happen at any memory
> access, there will be a #VC exception to notify the guest. And as this
> can happen anywhere, for example on a carefully crafted stack page set
> by userspace before doing SYSCALL, the only robust choice for #VC is to
> use IST.

The kernel won't ever touch the guest stack before restoring %rsp in the
syscall path, but the (minimum 2) memory accesses required to save the
user %rsp and load the kernel stack may be subject to #VC exceptions, as
are instruction fetches at the head of the SYSCALL path.

So yes - #VC needs IST.

Sorry for the noise.  (That said, it is unfortunate that the hypervisor
messing with the memory backing the guest #VC handler results in an
infinite loop, rather than an ability to cleanly terminate.)

~Andrew
