Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BEE449CA3
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 20:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhKHTtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 14:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbhKHTtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 14:49:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC26C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 11:46:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np3so8879849pjb.4
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 11:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KJmxlmsQWKYyJ3/YZjbsCZy7XQcCw93OjbQ/8xZZzDU=;
        b=b5V9BdRX7Ajb0U4wuI41JZUnsNVP0FHuALY+dhm+K1g5nN8MswPg5+I1wOH8HPaYcu
         94iGhHwnl/47WXZKlycxsDWNb+PPpumWA5z5bNNBJ/FJ97XXIpmpON87+nQDSxcBb/mJ
         JFf4GF6BRb7h+r17Nz5kSs9RXYacqAP5Ny7kW6V1my9z1bHNi15oRBZjnxqVRBFvMr/1
         vFjiuQa0+c3+mLkEjzCM+tknSLGZ1mCcnyJgeUkuF0GcNP1/yjfXefdJTKyr8AAQ4mL3
         oDP1o3lQ5QmjFj9TxeFHg1rVvnK1e2dMM2R2VN+1FO3qsfZoAOHn00Bn2758FudwAAQF
         aUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KJmxlmsQWKYyJ3/YZjbsCZy7XQcCw93OjbQ/8xZZzDU=;
        b=XSsdOeTyhmfh6/LUNC9jMdpPp5SIEu1c9H5IAjEDhzZGF6ckkpsxLmrR+FvkEoKKCK
         9zhR3/yMTfnlSVoeWUag9mitttQS1hKHWFaP7aMT3/eRK1U+d/eQJcN3KhYiFQ9kwE3B
         E/AHi8tVwEoXEJhtprxv4/s7yZXGXfd2bI+ihAhz6onNb9VGOltL3CYd+DeUmHXvveKM
         /MVblSun1m9GmsDuDZJt+Crn9DJAbiNyesdhSJE/R3WnnnKXF1Zt99oEo0KiUmDlb1BX
         Dk6Blx/b63S79UnfhMmTmltHPiSwBvEv76Snvl2+/MrCBarW0k3AnflQRCcy0Ccfqib6
         /yKA==
X-Gm-Message-State: AOAM5308JRWooLZHzHVD98kdXgJZ3m+boOXl/z/j/K8PB0PkmJIQH/bx
        Jig7FsK9QQLDSHv3aKTeOk7J8A==
X-Google-Smtp-Source: ABdhPJzPPYjxvXsdXstyvwBOWcxIFAiLX0thPTfNsXemE1x6XcevRxfX6dRSZtnCOAOos6uEQlpxgg==
X-Received: by 2002:a17:902:7c94:b0:13b:8d10:cc4f with SMTP id y20-20020a1709027c9400b0013b8d10cc4fmr1749655pll.54.1636400791922;
        Mon, 08 Nov 2021 11:46:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m12sm165487pjr.14.2021.11.08.11.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 11:46:31 -0800 (PST)
Date:   Mon, 8 Nov 2021 19:46:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/7] KVM: MMU: Add support for PKS emulation
Message-ID: <YYl+k3VbEieh9X2H@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-6-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811101126.8973-6-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Chenyi Qiang wrote:
>  * In particular the following conditions come from the error code, the
>  * page tables and the machine state:
> -* - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
> +* - PK is always zero unless CR4.PKE=1/CR4.PKS=1 and EFER.LMA=1
>  * - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
> -* - PK is always zero if U=0 in the page tables
> -* - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
> +* - PK is always zero if
> +*       - U=0 in the page tables and CR4.PKS=0
> +*       - U=1 in the page tables and CR4.PKU=0

I think it makes sense to completely rewrite this "table" or drop it altogether.
The "always zero" wording is nonsensical when there are multiple conditions for
"always".  And IMO the whole "PK is ... zero" thing is a bit awkward because it
leaves the uninitiated wondering what PK=0 even means ('1' == disabled is not the
most intuitive thing since most PTE bits are '1' = allowed).  Ugh, and re-reading
with context, that's not even what "PK" means here, this is actually referring to
PFEC.PK, which is all kinds of confusing because PFEC.PK is merely a "symptom" of
a #PF to due a protection key violation, not the other way 'round.

IMO this entire comment could use a good overhaul.  It never explicitly documents
the "access-disable" and "write-disable" behavior.  More below.

> +* - (PKRU/PKRS).WD is ignored if CR0.WP=0 and the access is a supervisor access.

Hrm.  The SDM contradicts itself.

Section 4.6.1 "Determination of Access Rights" says this for supervisor-mode accesses:

  If CR0.WP = 0, data may be written to any supervisor-mode address with a protection
  key for which write access is permitted.

but section 4.6.2 "Protection Keys" says:

  If WDi = 1, write accesses are not permitted if CR0.WP = 1. (If CR0.WP = 0,
  IA32_PKRS.WDi does not affect write accesses to supervisor-mode addresses with
  protection key i.)

I believe 4.6.1 is subtly wrong and should be "data access", not "write access".

  If CR0.WP = 0, data may be written to any supervisor-mode address with a protection
  key for which data access is permitted.
                ^^^^

Can you follow-up with someone to get the SDM fixed?  This stuff is subtle and
confusing enough as it is :-)

And on a very related topic, it would be helpful to clarify user-mode vs. supervisor-mode
and access vs. address.

How about this for a comment?

/*
 * Protection Key Rights (PKR) is an additional mechanism by which data accesses
 * with 4-level or 5-level paging (EFER.LMA=1) may be disabled based on the
 * Protection Key Rights Userspace (PRKU) or Protection Key Rights Supervisor
 * (PKRS) registers.  The Protection Key (PK) used for an access is a 4-bit
 * value specified in bits 62:59 of the leaf PTE used to translate the address.
 *
 * PKRU and PKRS are 32-bit registers, with 16 2-bit entries consisting of an
 * access-disable (AD) and write-disable (WD) bit.  The PK from the leaf PTE is
 * used to index the approriate PKR (see below), e.g. PK=1 would consume bits
 * 3:2 (bit 3 == write-disable, bit 2 == access-disable).
 *
 * The PK register (PKRU vs. PKRS) indexed by the PK depends on the type of
 * _address_ (not access type!).  For a user-mode address, PKRU is used; for a
 * supervisor-mode address, PKRS is used.  An address is supervisor-mode if the
 * U/S flag (bit 2) is 0 in at least one of the paging-structure entries, i.e.
 * an address is user-mode if the U/S flag is 0 in _all_ entries.  Again, this
 * is the address type, not the the access type, e.g. a supervisor-mode _access_
 * will consume PKRU if the _address_ is a user-mode address.
 *
 * As alluded to above, PKR checks are only performed for data accesses; code
 * fetches are not subject to PKR checks.  Terminal page faults (!PRESENT or
 * PFEC.RSVD=1) are also not subject to PKR checks.
 *
 * PKR write-disable checks for superivsor-mode _accesses_ are performed if and
 * only if CR0.WP=1 (though access-disable checks still apply).
 *
 * In summary, PKR checks are based on (a) EFER.LMA, (b) CR4.PKE or CR4.PKS,
 * (c) CR4.WP, (d) the PK in the leaf PTE, (e) two bits from the corresponding
 * PKR{S,U} entry, (f) the access type (derived from the other PFEC bits), and
 * (g) the address type (retrieved from the paging-structure entries).
 *
 * To avoid conditional branches in permission_fault(), the PKR bitmask caches
 * the above inputs, except for (e) the PKR{S,U} entry.  The FETCH, USER, and
 * WRITE bits of the PFEC and the effective value of the paging-structures' U/S
 * bit (slotted into the PFEC.RSVD position, bit 3) are used to index into the
 * PKR bitmask (similar to the 4-bit Protection Key itself).  The two bits of
 * the PKR bitmask "entry" are then extracted and ANDed with the two bits of
 * the PKR{S,U{} register corresponding to the address type and protection key.
 *
 * E.g. for all values where PFEC.FETCH=1, the corresponding pkr_bitmask bits
 * will be 00b, thus masking away the AD and WD bits from the PKR{S,U} register
 * to suppress PKR checks on code fetches.
*/
