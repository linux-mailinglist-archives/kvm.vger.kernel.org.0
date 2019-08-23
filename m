Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F999AC6B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391873AbfHWKGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 06:06:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58623 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391851AbfHWKGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 06:06:23 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46FH9T5G9Tz9sBp; Fri, 23 Aug 2019 20:06:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566554781; bh=QLQsTAOZE1gGL3/Mhe7B43PHJuPQ9BKbedBn6LgDPLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AEVd1JcU6F9umiAv1HUNaZtOkH0Ssq6EKNB92AZOJTAlCP3HveF9B1OrbMZy7RUXS
         MWcymwiBC8XRU74UntlrxHsRI5Ex522imgkFP94b+qeFOk6KvttiKkvq4LjhdyAHWS
         wF+qkqTPfIub12ItyKTQL4Hn9DjiXHEtKfz9BWSE8AGHM3mFl/XZ+kmRUXKvcmQm1W
         STx42UsC3fVdVIcwDJb3GBi+U+FaAMnNBmyCHsijmriNGYZs/SU7t+QV3bn10voMQX
         87QEMHDbeZqeUh28i8uOqvHouYpeo5Scw0uzibG+P1EyT8eh6+wQ+UgdwD3+hS6UmI
         7o0e+WIaCAzog==
Date:   Fri, 23 Aug 2019 20:04:54 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Define usage types for rmap array
 in guest memslot
Message-ID: <20190823100454.GA11357@blackberry>
References: <20190820061349.28995-1-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820061349.28995-1-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 04:13:49PM +1000, Suraj Jitindar Singh wrote:
> The rmap array in the guest memslot is an array of size number of guest
> pages, allocated at memslot creation time. Each rmap entry in this array
> is used to store information about the guest page to which it
> corresponds. For example for a hpt guest it is used to store a lock bit,
> rc bits, a present bit and the index of a hpt entry in the guest hpt
> which maps this page. For a radix guest which is running nested guests
> it is used to store a pointer to a linked list of nested rmap entries
> which store the nested guest physical address which maps this guest
> address and for which there is a pte in the shadow page table.
> 
> As there are currently two uses for the rmap array, and the potential
> for this to expand to more in the future, define a type field (being the
> top 8 bits of the rmap entry) to be used to define the type of the rmap
> entry which is currently present and define two values for this field
> for the two current uses of the rmap array.
> 
> Since the nested case uses the rmap entry to store a pointer, define
> this type as having the two high bits set as is expected for a pointer.
> Define the hpt entry type as having bit 56 set (bit 7 IBM bit ordering).
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Thanks, applied to my kvm-ppc-next branch.

Paul.
