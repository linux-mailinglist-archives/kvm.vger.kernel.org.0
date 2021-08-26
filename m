Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCFD3F864B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242017AbhHZLXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242013AbhHZLW7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629976932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2D+VI8N4DgUW8kadS3gWrCkPlp7cyXXfyrkd1lGeiM=;
        b=UnXwxpYX9UGqBQ7i7lTwHI0GX9TyqiWfcfFrMB7p8flRDzYq7XCh3BCu5X02oUNX5yo2Zl
        25Vcz4WULLO6C0Bc87PVT8yantzSc0EsVHfBRQgZkcjqW8DJvLCHnIDkKbCYDhLxAe0FAV
        QOHuyELV2yoyZ3pMUjAZASTvPvh+1xA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-awFflcRLOUqYpQAyvzchGg-1; Thu, 26 Aug 2021 07:22:11 -0400
X-MC-Unique: awFflcRLOUqYpQAyvzchGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7C01875112;
        Thu, 26 Aug 2021 11:22:09 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 766B01002388;
        Thu, 26 Aug 2021 11:22:05 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C0B8B18003AA; Thu, 26 Aug 2021 13:22:03 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:22:03 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 19/44] hw/i386/e820: introduce a helper function
 to change type of e820
Message-ID: <20210826112203.2r52zqh24tgdeogk@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <57f1c8c44405aadc421bc1fd5b6cb41f55b10e20.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57f1c8c44405aadc421bc1fd5b6cb41f55b10e20.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:49PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a helper function, e820_change_type(), that change
> the type of subregion of e820 entry.

The entry is splited into multiple if needed.

> The following patch uses it.

Used to mark ram regions used for firmware as reserved.

More verbose commit messages please, it makes review easier if I don't
have to read the details out of the code changes.

thanks,
  Gerd

