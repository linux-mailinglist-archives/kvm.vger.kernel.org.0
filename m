Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5161E5DECD
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 09:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGCHXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 03:23:50 -0400
Received: from foss.arm.com ([217.140.110.172]:39688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCHXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 03:23:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B08622B;
        Wed,  3 Jul 2019 00:23:49 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32F803F718;
        Wed,  3 Jul 2019 00:23:49 -0700 (PDT)
Subject: Re: [PATCH kvmtool] README: Add maintainers section
To:     Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Cc:     marc.zyngier@arm.com
References: <20190628112619.20426-1-will@kernel.org>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <e6763a48-6f9d-9c7a-cf7f-af6baffd6a39@arm.com>
Date:   Wed, 3 Jul 2019 08:23:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190628112619.20426-1-will@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 28/06/2019 12:26, Will Deacon wrote:
> Julien has kindly offered to help maintain kvmtool, but it occurred to
> me that we don't actually provide any maintainer contact details in the
> repository as it stands.
> 
> Add a brief "Maintainers" section to the README, immediately after the
> "Contributing" section so that people know who to nag about merging and
> reviewing patches.
> 
> Cc: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  README | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/README b/README
> index 52124b87a5e2..591f84f3f489 100644
> --- a/README
> +++ b/README
> @@ -111,3 +111,9 @@ added automatically by issuing the command
>   git config format.subjectprefix "PATCH kvmtool"
>  
>  in the git repository.
> +
> +Maintainers
> +-----------
> +
> +kvmtool is maintained by Will Deacon <will@kernel.org> and Julien Thierry
> +<julien.thierry@arm.com>.

Thanks for addition.

Acked-by: Julien Thierry <julien.thierry@arm.com>

-- 
Julien Thierry
