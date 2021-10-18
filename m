Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8C431B49
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhJRNcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 09:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhJRNa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E73F6138B;
        Mon, 18 Oct 2021 13:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634563692;
        bh=+OOvU9Svv4jObE4KSKWKKO2RN2uQPBkRuRPTzY+YrVQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ekX1AEPQhIzCpNPtQXxbsuLZdJhhlMfWeLsMXcaI3rQXD7g98gk5xIxmIGX5N41ha
         6L9IQdzMW1LMsASZcxekJvgywPkA6CTsnLzKNxx/tqFcysRram98HsoHERnyCfycBM
         vUbeoRJuCkG2ZM8cJI+g8xn4siORWUPQHoJdOWmAp1LyeUHomnAFRHqJOts42Ah85t
         EjgkC+0ixggpoVY2O09sM9H77vyxA02zdvzQfoE2I83Kc1S1u3ocpqJKNTUv2TVHau
         BOpco8M+BpsRLamSRMtbg/2L4I6x47TV781MEibtgk0uYoY6Mis6J/yonRBLBmxfsV
         /cEdRRBwco0qg==
Message-ID: <11d5fba1fd88262691cff315c076b5ad2019cc49.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, bp@suse.de
Date:   Mon, 18 Oct 2021 16:28:10 +0300
In-Reply-To: <337bafa9-a627-f50a-f73c-0e36c2282d55@redhat.com>
References: <20211016071434.167591-1-pbonzini@redhat.com>
         <5f816a61bb95c5d3ea4c26251bb0a4b044aba0e6.camel@kernel.org>
         <337bafa9-a627-f50a-f73c-0e36c2282d55@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-18 at 15:03 +0200, Paolo Bonzini wrote:
> On 18/10/21 14:51, Jarkko Sakkinen wrote:
> > BTW, do you already have patch for QEMU somewhere, which uses
> > this new functionality? Would like to peek at it just to see
> > the usage pattern.
>=20
> Yang was going to post them this week; the way to trigger them is just=
=20
> to do a reboot from within a Linux guest.
>=20

Yang, please CC to me the full patch set, if possible. Thanks.

/Jarkko
