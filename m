Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09D2407B2
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgHJOix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 10:38:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgHJOiw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 10:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597070332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owTQ/60W4cl8k08yaQREW3e0LvIAZEObqjO56lvs13E=;
        b=LbCI7g4MlXUInLSXHBRg5AAovVqLQO9NiXsS7IgAfPuV17hRtm/eIcls8T/S4Xf+OXqSZR
        OnVv3U16VNFd5sNLada/i3rOr8hiar2eWbPEQhWY89V57Av5GjnSE+GgtXRoJFC/jK4NGE
        OgO/Hw4eeCiRCeTkT15ihjYWgbT4U/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-cLOIpDELM7yIxRV7lePCCA-1; Mon, 10 Aug 2020 10:38:48 -0400
X-MC-Unique: cLOIpDELM7yIxRV7lePCCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 187638015F4;
        Mon, 10 Aug 2020 14:38:47 +0000 (UTC)
Received: from gondolin (ovpn-112-218.ams2.redhat.com [10.36.112.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEAA38AC2D;
        Mon, 10 Aug 2020 14:38:42 +0000 (UTC)
Date:   Mon, 10 Aug 2020 16:38:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new
 skey test and add test to unittests.cfg
Message-ID: <20200810163840.1eebeeb3.cohuck@redhat.com>
In-Reply-To: <20200807111555.11169-3-frankja@linux.ibm.com>
References: <20200807111555.11169-1-frankja@linux.ibm.com>
        <20200807111555.11169-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Aug 2020 07:15:54 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> When an exception new psw with a storage key in its mask is loaded
> from lowcore, a specification exception is raised. This differs from
> the behavior when trying to execute skey related instructions, which
> will result in special operation exceptions.
> 
> Also let's add the test to unittests.cfg so it is run more often.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/skrf.c        | 79 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  2 files changed, 83 insertions(+)

Didn't review deeply.

Acked-by: Cornelia Huck <cohuck@redhat.com>

