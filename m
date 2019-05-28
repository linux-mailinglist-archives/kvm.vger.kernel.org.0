Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2F2BD21
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 04:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfE1COM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 22:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbfE1COM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 22:14:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0ACCC3082B15
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 02:14:12 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 295D95C28E;
        Tue, 28 May 2019 02:14:09 +0000 (UTC)
Date:   Tue, 28 May 2019 10:14:07 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH v2 1/4] kvm: selftests: rename vm_vcpu_add to
 vm_vcpu_add_with_memslots
Message-ID: <20190528021407.GA22519@xz-x1>
References: <20190527143141.13883-1-drjones@redhat.com>
 <20190527143141.13883-2-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190527143141.13883-2-drjones@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 28 May 2019 02:14:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 04:31:38PM +0200, Andrew Jones wrote:
> This frees up the name vm_vcpu_add for another use.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu
