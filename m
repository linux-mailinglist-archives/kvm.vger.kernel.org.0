Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836AD24D4FA
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHUM2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbgHUM2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 08:28:09 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BC220724;
        Fri, 21 Aug 2020 12:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598012889;
        bh=TR7yUwBCP5/uZdCMBofII8BiqO4AGqWMPxIvdtLulnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqgjl4dn+MwdkgfvsOZB1suISrTfRNuI+qHx9WB5Wt06KhIyhQHEW7nclzhjR0yku
         F+eoEdyK1cOnV0aYBG0UPLe76uiJIT9FXU6e6PSXmwd0s1WWfNeb8RhLIvnOXgW8TS
         ryfneFJGZvq6y3mjd819xAw3aLkhjEdnt/mRLzBM=
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool] update_headers.sh: Remove arm architecture
Date:   Fri, 21 Aug 2020 13:28:03 +0100
Message-Id: <159801229349.4167827.4870196616635210998.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200810153828.216821-1-alexandru.elisei@arm.com>
References: <20200810153828.216821-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Aug 2020 16:38:28 +0100, Alexandru Elisei wrote:
> KVM host support for the arm architecture was removed in commit
> 541ad0150ca4 ("arm: Remove 32bit KVM host support"). When trying to sync
> KVM headers we get this error message:
> 
> $ util/update_headers.sh /path/to/linux
> cp: cannot stat '/path/to/linux/arch/arm/include/uapi/asm/kvm.h': No such file or directory
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] update_headers.sh: Remove arm architecture
      https://git.kernel.org/will/kvmtool/c/90b2d3adadf2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
