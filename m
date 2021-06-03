Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAAE39AAAE
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFCTKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 15:10:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhFCTKo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 15:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622747338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/mFjGwzyKUf+Rm3Ll5eTAt6+wFwuAac5nwblAOi9dag=;
        b=CrblsM2yvJqdqZvJaLmFQzT0voxJeVSuVOTA6ruIrN3xCg5W4nC3ARCQVtUjKrYP2RQnBc
        jHpTiIM7bnKuRcgo3bIEuYZ5RYqwuqirieiUbUiC0LS2a/CtzxIrzauCt4p4rjHyuMSSfH
        QK9Nc6NGnGFm5zGZBxrJI9trMQ/dESI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-vjY9gVcfODOTIhWfK8Vbsg-1; Thu, 03 Jun 2021 15:08:51 -0400
X-MC-Unique: vjY9gVcfODOTIhWfK8Vbsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E21A4DF8A4;
        Thu,  3 Jun 2021 19:08:49 +0000 (UTC)
Received: from localhost (ovpn-120-94.rdu2.redhat.com [10.10.120.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A5572C159;
        Thu,  3 Jun 2021 19:08:46 +0000 (UTC)
Date:   Thu, 3 Jun 2021 15:08:45 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] Update Linux headers to 5.13-rc4
Message-ID: <20210603190845.h5xczleyiix2d5do@habkost.net>
References: <20210601201741.2599517-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210601201741.2599517-1-ehabkost@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 04:17:41PM -0400, Eduardo Habkost wrote:
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> KVM_RUN_X86_BUS_LOCK is a requirement for:
>   [PATCH v4] i386: Add ratelimit for bus locks acquired in guest
>   Message-Id: <20210521043820.29678-1-chenyi.qiang@intel.com>

I forgot to git-add the new virtio_bt.h and virtio_snd.h files,
and this now conflicts with commit 3ea1a80243d5
("target/i386/sev: add support to query the attestation report").
I will send v2.

-- 
Eduardo

