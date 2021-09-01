Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547413FD26D
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 06:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbhIAEkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 00:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237454AbhIAEkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 00:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE46960724;
        Wed,  1 Sep 2021 04:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630471149;
        bh=1yBJDx44Nya7xDZWygpeSnX032AHSUDSn5k/kmjUYjw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cJz5MCwvixy3dZNyqhBPmcEFHUX1/m1Eb6agmQ/Zk3uBC3tdORyD12hQekvfS7lqH
         SyIt2iybQoEbu9oyPk6OlQauD4r/JMBqIrubFrq3yd5NglJicQcLj7r2kJMkpEK3oE
         oCQnutVUJNInq2uWxJEAnn6sVX1QaOE3aGdCSyEqtm2yWigK3u9pEWmitex/UN7FGl
         AVevGKlqYEf3kuPlHu6B5h5zZncMVeNUFGH6jpoLp1HY86xPGaXV2QKly5eqri0pR8
         1hRDPjy7gCfPsljQdll0kCbRaK/KKzgNZe/vRjk4I9gh7IDdP5y+pv8CTFQuvi5Jp7
         y/a/FkipvajOA==
Message-ID: <1dffe39c34dead9dd1a3782344b637757404d0c6.camel@kernel.org>
Subject: Re: [PATCH 1/4] KVM: x86: Introduce .pcpu_is_idle() stub
 infrastructure
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tianqiang Xu <skyele@sjtu.edu.cn>, x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        kvm@vger.kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Wed, 01 Sep 2021 07:39:06 +0300
In-Reply-To: <20210831015919.13006-1-skyele@sjtu.edu.cn>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-31 at 09:59 +0800, Tianqiang Xu wrote:
> This patch series aims to fix performance issue caused by current
> para-virtualized scheduling design.

Series?

This looks to me like a patch, not a cover letter.

If you want a cover letter, please make one.

/Jarkko
