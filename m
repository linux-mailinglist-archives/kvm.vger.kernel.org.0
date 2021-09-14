Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6972940B41A
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhINQG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhINQGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:06:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A3A610FB;
        Tue, 14 Sep 2021 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631635508;
        bh=b1wd+Y+puqNJWrKtzvXtWggGD1x8IS+rF9VP5msmM8c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SFQDXYnGIxAvYWnKJ087Tx8/u9tm/NnIW5YjUA8Kfl+MwJ2E7PiyjsDxhcrCY3bTi
         9m42fbL4lejpy5/nxUYV5FpA9hlGho3PYSNWRRjkL16GtAeK9ioOgH1GveIbgpT/lD
         iutqhRcrqKc1Lm/vf2A+rfEILD/F3kBSt0wys6q3IQ7B1CzN+DklVnDNinWS59SyKB
         sLhtm9dGKVheA13yiUSGUuffFuguTzoGtCjpOc6EXgWJ2CxAaEMQouxLLQH3HfEFul
         jz7Prr5qn+pvN/VdOtJ8fCp2Fi/zI7eSP66Mr34XWm9s+hSHIf/CHD8GnDNwZEQvDx
         BMAGpCVnoq0tQ==
Message-ID: <2bc53d87b3bacf78e2bbed8efcdbbf8553a7d6d5.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 14 Sep 2021 19:05:05 +0300
In-Reply-To: <734abf89-8be2-dd13-b649-fde5744ba465@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
         <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
         <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
         <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
         <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
         <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
         <734abf89-8be2-dd13-b649-fde5744ba465@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 07:36 +0200, Paolo Bonzini wrote:
> On 13/09/21 23:13, Jarkko Sakkinen wrote:
> > > Apart from reclaiming, /dev/sgx_vepc might disappear between the firs=
t
> > > open() and subsequent ones.
> >=20
> > If /dev/sgx_vepc disappears, why is it a problem *for the software*, an=
d
> > not a sysadmin problem?
>=20
> Rather than disappearing, it could be that a program first gets all the=
=20
> resources it needs before it gets malicious input, and then enter a=20
> restrictive sandbox.  In this case open() could be completely forbidden.
>=20
> I will improve the documentation and changelogs when I post the non-RFC=
=20
> version; that could have been done better, sorry.
>=20

No worries, just trying to get bottom of the actual issue.

/Jarkko
