Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524CFF3CD
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfD3KL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: from ozlabs.org ([203.11.71.1]:50577 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfD3KL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky3jZPz9sML; Tue, 30 Apr 2019 20:11:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=wuXnfxa55akvo2zINYPhfogd2TVE2PZgN/yl606B4eg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmDeCAHbYYfh/B6hyYQBy8IR2yVhRrbPi+F9yDfD8rqdwoDww+wzuHgDv/z+yvKL0
         Um1dwJ6yIQuE3O1eFjSk3GtCPH6hEUlfXxRinSwjeKSXzOcv+Eb+JVYstGBBpfQrSk
         NCPnjvKkmmCYVIZmqDSUaVk9ZPUI9iGd8WmqACl8pDgSTlHjmG8JJcPfH/9UdaBdwI
         d9OJm8efhqFdWQrxLNdze6Aw8eLEXm9MBjDXW2K4Lmn6IeyjOD8eC2LgFPSasz3iMT
         eHr6Au213H/NBe6sRzGJNhso8ZxaTJY+tVVA2Giys0jBBAHvkjYc1kGNVVU9goy1f6
         xPM9ILP/cfCMg==
Date:   Tue, 30 Apr 2019 19:59:59 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: PPC: Book3S HV: Implement virtual mode
 H_PAGE_INIT handler
Message-ID: <20190430095959.GA32205@blackberry>
References: <20190322060545.24166-1-sjitindarsingh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322060545.24166-1-sjitindarsingh@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 22, 2019 at 05:05:44PM +1100, Suraj Jitindar Singh wrote:
> Implement a virtual mode handler for the H_CALL H_PAGE_INIT which can be
> used to zero or copy a guest page. The page is defined to be 4k and must
> be 4k aligned.
> 
> The in-kernel handler halves the time to handle this H_CALL compared to
> handling it in userspace for a radix guest.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Thanks, both patches applied to my kvm-ppc-next tree.

Paul.
