Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C7339EE6C
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 07:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFHFxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 01:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhFHFxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 01:53:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C92BC061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 22:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Gd4CrSgsZ0GAgAe1Eo+04dMf/P
        MQBqfiV65hTR8xYFvyJuUpggk/u19jm37QnIZt4I/PEWyG/XjBbOQ1l91GUbgZEql4CsNTRs9dlLQ
        r50bhouSwSpa+vZ6+9EPl6Og9ReMJE77QDSwXiqvesfts7zXQOmIkXrGbQqEz/RdG7AF05rs7aID4
        kaw4z1rZgRKMD4h2nkuDg0wMMD9GGXhNDSI2qi4VFC6RA+DAAU3ZHuMYZ4lZ8gWYsXscxYjAFPpO5
        CKFWTZSEgtTjjLkzxbHDC/wsaLjXxM82bDjZx4Xou/G/5mH1daz9JN1rwhCqSv8Mrd4rG7d9I7SzX
        PLcm5lqg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqUeB-00Gbr7-KK; Tue, 08 Jun 2021 05:51:37 +0000
Date:   Tue, 8 Jun 2021 06:51:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <YL8FY9BeAn7S9P5z@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
