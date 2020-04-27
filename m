Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493431BAC1D
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgD0SPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:15:13 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:21981 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgD0SPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1588011312;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KBBurnKwQk0mJMwfeqD0uyO9fh4p+KVZdnBjFEeHlv4=;
  b=RICYFDiWA2SWatqKnhjWWBhAgHgVnhVrTNm4ZXSrt1WNaD/RlDuCMcRF
   SlsMzz/VXZLs+Y4bKg+FusohTZY7yJMrphwWTA1qBCVjc0xfrcwN5ekHB
   RPs87Retey/GxdO3rIB8Ym0NSDhHm0DuIsrXW6H11sZOpiD12NTPNezV0
   Y=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa6.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: ELrzJwrXWLafnbRhhOpo9sUmi2ptJ2dbSjQcB604T4YpDGeUhU1Zj28fONXyGGCdtv0J2MzLme
 XdKmX8FYTey36XrM/OsB2JaDUUC99LUtGFxpHQvrJIgJJR9qtSTItmghnWelKsCmEv4Es0/loA
 7nD6hg1DAWb6O67JNQn9pDkGbYOW6P1mCIEA7IhM8rR37q2YS/ikdhotFDI33VW5CLeFwRmvlX
 VgHNdN4Igthunl6nAHb98NDXTO7YJJbRh5jj5abE4kLhAEiCXMk9j5b/g9dQiXF8CDbK52pYgh
 Kw8=
X-SBRS: 2.7
X-MesageID: 16722682
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.73,325,1583211600"; 
   d="scan'208";a="16722682"
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
To:     Andy Lutomirski <luto@kernel.org>
CC:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        "Dave Hansen" <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "Mike Stunes" <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
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
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <57aa7412-b9e1-3331-ba30-bb6daaa28ff3@citrix.com>
Date:   Mon, 27 Apr 2020 19:15:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/2020 18:37, Andy Lutomirski wrote:
> On Sat, Apr 25, 2020 at 3:10 PM Andy Lutomirski <luto@kernel.org> wrote:
>> On Sat, Apr 25, 2020 at 1:23 PM Joerg Roedel <joro@8bytes.org> wrote:
>>> On Sat, Apr 25, 2020 at 12:47:31PM -0700, Andy Lutomirski wrote:
>>>> I assume the race you mean is:
>>>>
>>>> #VC
>>>> Immediate NMI before IST gets shifted
>>>> #VC
>>>>
>>>> Kaboom.
>>>>
>>>> How are you dealing with this?  Ultimately, I think that NMI will need
>>>> to turn off IST before engaging in any funny business. Let me ponder
>>>> this a bit.
>>> Right, I dealt with that by unconditionally shifting/unshifting the #VC IST entry
>>> in do_nmi() (thanks to Davin Kaplan for the idea). It might cause
>>> one of the IST stacks to be unused during nesting, but that is fine. The
>>> stack memory for #VC is only allocated when SEV-ES is active (in an
>>> SEV-ES VM).
>> Blech.  It probably works, but still, yuck.  It's a bit sad that we
>> seem to be growing more and more poorly designed happens-anywhere
>> exception types at an alarming rate.  We seem to have #NM, #MC, #VC,
>> #HV, and #DB.  This doesn't really scale.
> I have a somewhat serious question: should we use IST for #VC at all?
> As I understand it, Rome and Naples make it mandatory for hypervisors
> to intercept #DB, which means that, due to the MOV SS mess, it's sort
> of mandatory to use IST for #VC.  But Milan fixes the #DB issue, so,
> if we're running under a sufficiently sensible hypervisor, we don't
> need IST for #VC.
>
> So I think we have two choices:
>
> 1. Use IST for #VC and deal with all the mess that entails.
>
> 2. Say that we SEV-ES client support on Rome and Naples is for
> development only and do a quick boot-time check for whether #DB is
> intercepted.  (Just set TF and see what vector we get.)  If #DB is
> intercepted, print a very loud warning and refuse to boot unless some
> special sev_es.insecure_development_mode or similar option is set.
>
> #2 results in simpler and more robust entry code.  #1 is more secure.
>
> So my question is: will anyone actually use SEV-ES in production on
> Rome or Naples?  As I understand it, it's not really ready for prime
> time on those chips.  And do we care if the combination of a malicious
> hypervisor and malicious guest userspace on Milan can compromise the
> guest kernel?  I don't think SEV-ES is really mean to resist a
> concerted effort by the hypervisor to compromise the guest.

More specifically, it is mandatory for hypervisors to intercept #DB to
defend against CVE-2015-8104, unless they're willing to trust the guest
not to tickle that corner case.

This is believed fixed with SEV-SNP to allow the encrypted guest to use
debugging functionality without posing a DoS risk to the host.  In this
case, the hypervisor is expected not to intercept #DB.

If #DB is intercepted, and #VC doesn't use IST, malicious userspace can
cause problems with a movss-delayed breakpoint over SYSCALL.

The question basically whether it is worth going to the effort of making
#VC IST and all the problems that entails, to cover one corner case in
earlier hardware.

Ultimately, this depends on whether anyone plans to put SEV-ES into
production on pre SEV-SNP hardware, and if developers using pre-SEV-SNP
hardware are happy with "don't run malicious userspace" or "don't run
malicious kernels and skip the #DB intercept" as a fair tradeoff to
avoid the #VC IST fun.

~Andrew
