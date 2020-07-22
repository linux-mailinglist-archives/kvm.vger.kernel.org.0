Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A914229101
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 08:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgGVGgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 02:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 02:36:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9945CC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 23:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iJ75CqVLwzufpVl7TOrDE+dI6rQEx49erHU0GlW5mZk=; b=a9dXBDxAmmzaG1GtIJffAtPthH
        y4WiXP/7qguBaDZIKPAV9hRcoJw974SpSyPgX4PWVnEi1FvyHgpSUtchsvbTL3o3gaSV3V0MNv8IM
        GpRAlA9q8gvPqAohT6qr5onMVwBRwC4Fx8cw/6+519rf88yXP3/ixAH9SGhCC3M6xLlHIQB3Zijt/
        ndDt3n5sPEPLk8pbUgh/z4UNee66RrT/pdWjw/YEsoTPbCxF25CBcGHCWfs0SL+SYs87mss9cPlmR
        xK/NQa97EFeRxaGqjvy4RhaUv0MY9VEDrx0WoUu+kRFai6T8muuTQBKtJXMczH3uiTMoVVDBp+uw6
        A4vxXogg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jy8Ml-0005U8-Gd; Wed, 22 Jul 2020 06:36:35 +0000
Date:   Wed, 22 Jul 2020 07:36:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Adalbert Laz??r <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>
Subject: Re: [PATCH v9 01/84] signal: export kill_pid_info()
Message-ID: <20200722063635.GA20491@infradead.org>
References: <20200721210922.7646-1-alazar@bitdefender.com>
 <20200721210922.7646-2-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721210922.7646-2-alazar@bitdefender.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 12:07:59AM +0300, Adalbert Laz??r wrote:
> From: Mathieu Tarral <mathieu.tarral@protonmail.com>
> 
> This function is used by VM introspection code to ungracefully shutdown
> a guest at the request of the introspection tool.
> 
> A security application will use this as the last resort to stop the
> spread of a malware from a guest.

I don't think your module has any business doing this.  If at all
it would be an EXPORT_SYMBOL_GPL, but the export is very questionable
and needs a much better justification.
