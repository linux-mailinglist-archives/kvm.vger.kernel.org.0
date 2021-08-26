Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B9F3F86EA
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242442AbhHZMCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242434AbhHZMCm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629979315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTHP8Ry/DO/IuLNpWWeVVCxCQtKNXgqO0Ii/9aqphjo=;
        b=B7ivi439XkbVdAL1b6Z8XAs0MvI+u7YNyuZZyUHHJb+Hk71xrz0hGvVGQ8Qle90cnCctU6
        F7d75Nm2AsSZXDfhVwo5MY06MED3MnHedhK+8XS2JHZyBmNhKRVOxkOnNdtJ+jcrfFjp6R
        up2IweGq+EnhbVuqjR/+LQ2ZGo+HYfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-zZSuDz7WP6ONhOMhuGsqNQ-1; Thu, 26 Aug 2021 08:01:54 -0400
X-MC-Unique: zZSuDz7WP6ONhOMhuGsqNQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A141F100E322;
        Thu, 26 Aug 2021 12:01:52 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 590E31002F12;
        Thu, 26 Aug 2021 12:01:52 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C6EDA18003AA; Thu, 26 Aug 2021 14:01:50 +0200 (CEST)
Date:   Thu, 26 Aug 2021 14:01:50 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 34/44] target/i386/tdx: set reboot action to
 shutdown when tdx
Message-ID: <20210826120150.w36qf3ac2xf2dhnp@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> In TDX CPU state is also protected, thus vcpu state can't be reset by VMM.
> It assumes -action reboot=shutdown instead of silently ignoring vcpu reset.

Again, better throw an error instead of silently fixing up settings.

take care,
  Gerd

