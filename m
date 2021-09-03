Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608EA3FFAC7
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 08:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347491AbhICHAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 03:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346599AbhICHAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 03:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35FEE60F9C;
        Fri,  3 Sep 2021 06:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630652354;
        bh=Q4+XwPN+M1cvWkQuGrtu9reB+WwKcJKnoIF/ojmKBVM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XN2ippLWQO03bK2sMb6hqrkdTyYHIhPz9iZwFpJgB7QBDo8rWvQ4xqnbL5gU9Es2s
         17jxFHAd/XT1DrU/jkwXtW363y+iTEMpxGiofl69XGp09ZR/v8OB0cLb2gy2y+fvQd
         jCQap+vXUfakWwWdbRWu31f+HpaqITe3E6TdfwEZaF3YbdSm8e6LXoEqmgO/OkZOmF
         V2pUpB+c5km+hBzOoSkrPfxcnoD/tqDq+E39QrFolaS4cJRsmRLCcqDeGwAs/BGCWx
         xZiel+RBUcWpHQ+RN7pS9FO8aydVvafLD0De1OWSP02PbRMMCwOXbqJIH5w4e2VV3j
         67ghs2Cawuepw==
Message-ID: <3c0a8a858a805789b9c71b7e54e316403fc41d5e.camel@kernel.org>
Subject: Re: [PATCH v2] KVM: x86: Handle SRCU initialization failure during
 page track init
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     tcs.kernel@gmail.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Date:   Fri, 03 Sep 2021 09:59:12 +0300
In-Reply-To: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
References: <1630636626-12262-1-git-send-email-tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 10:37 +0800, tcs.kernel@gmail.com wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
>=20
> Check the return of init_srcu_struct(), which can fail due to OOM, when
> initializing the page track mechanism.  Lack of checking leads to a NULL
> pointer deref found by a modified syzkaller.
>=20
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reported-by: TCS Robot <tcs_robot@tencent.com>

I'd drop reported-by. It's not a person (I guess) and the desc
is self-contained already.

Anyway,

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko


