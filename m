Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF00413AF1
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 21:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhIUTs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 15:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhIUTs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 15:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05CD661090;
        Tue, 21 Sep 2021 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632253617;
        bh=Vd72d03O7vyO6/ntGqgJQ7bBsZ/+rDIvCZUgBZtoU0c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C8uJtnAm4Mq5eVYm0dKWWTUGx2AeG8B82zVLfuy2KOCgkLZ5SA+lo4Y+XxLYxvwga
         dmbG0hTRc60XBHH79QvT96Fe0f2OyLJVbO6iZwojfwHYAS5+S9MOburXbR3KUmtRyz
         ZTLhpPs3Sookcyfmj5CQsFtmfn5ncYl9je8Ep3+WGxK8TyW+rEFFrMRJvPRm60qV19
         B3y1LYEP2o3/WbT3LAuCp+pCgpYtaDj5EW/mH2eodVKriTDimPRT2yZwZBsJ3DY/7Y
         oHTk2DY4kys5tlZeU0oWKja/kCA8CFYOiNVbEVsylZHB0Ceq44zQEXQqy49Q6YcsaV
         OmyoUm24wQ+YQ==
Message-ID: <5d0b85ed3d70ce75033a7f546ad6a3c0bec32271.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Tue, 21 Sep 2021 22:46:55 +0300
In-Reply-To: <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
References: <20210920125401.2389105-1-pbonzini@redhat.com>
         <20210920125401.2389105-2-pbonzini@redhat.com>
         <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-21 at 22:44 +0300, Jarkko Sakkinen wrote:
> Even to a Linux guest, since EPC should stil be represented in the state =
that
> matches the hardware.  It'd be essentially a corrupted state, even if the=
re was
> measures to resist this. Windows guests failing is essentially a side-eff=
ect
> of an issue, not an issue in the Windows guests.

Ugh, typos, sorry. Even to a Linux guest it would be illegit what I was mea=
ning
to say...

/Jarkko

