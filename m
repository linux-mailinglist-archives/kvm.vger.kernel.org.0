Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D64375B65
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhEFTIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233217AbhEFTIa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 15:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620328052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TgGRM+ReCWnEJOnYf4hSAh/OAMQkcq+MlZhUWMnz+ok=;
        b=NizREWK8xFYd5ygrQzfVZteWUE2Bjap2AV1Z6ITZRwpPiALfGuiKjva3Pr4hOorFZPZ89N
        xcquJusd3XoHR6drM9MuLD31BzWRUN1LKwJERC8eIb/FnocroDza1LpWAPbzNdBwINd6Ds
        f33fXpU9eJmqOobnNIp9XLFrfLJUI6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-QN36qnc-NkSPXb8b6gKSag-1; Thu, 06 May 2021 15:07:28 -0400
X-MC-Unique: QN36qnc-NkSPXb8b6gKSag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 872998014D8;
        Thu,  6 May 2021 19:07:27 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 922485D735;
        Thu,  6 May 2021 19:07:23 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id E6EAA40E6DF4; Thu,  6 May 2021 16:07:03 -0300 (-03)
Message-ID: <20210506185732.609010123@redhat.com>
User-Agent: quilt/0.66
Date:   Thu, 06 May 2021 15:57:32 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch 0/2] VMX: configure posted interrupt descriptor when assigning device
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configuration of the posted interrupt descriptor is incorrect when devices 
are hotplugged to the guest (and vcpus are halted).

See patch 2 for details.


