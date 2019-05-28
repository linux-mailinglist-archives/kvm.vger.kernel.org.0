Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800AC2BD22
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 04:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfE1CO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 22:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbfE1CO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 22:14:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DFCF356E7
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 02:14:26 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C30F1A91D;
        Tue, 28 May 2019 02:14:24 +0000 (UTC)
Date:   Tue, 28 May 2019 10:14:22 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH v2 2/4] kvm: selftests: introduce vm_vcpu_add
Message-ID: <20190528021422.GB22519@xz-x1>
References: <20190527143141.13883-1-drjones@redhat.com>
 <20190527143141.13883-3-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190527143141.13883-3-drjones@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 28 May 2019 02:14:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 04:31:39PM +0200, Andrew Jones wrote:
> vm_vcpu_add() just adds a vcpu to the vm, but doesn't do any
> additional vcpu setup.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu
