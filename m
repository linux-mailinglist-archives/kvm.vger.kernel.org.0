Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA31E1B3987
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 09:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDVH7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 03:59:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54997 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgDVH7k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 03:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587542380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lExI0D2ulJHPcIh5b+5aOm329j4dsrttLmhGfF58L/g=;
        b=VSqv5VTmA1eXqfKo4uV5px4wqDzYv93HFhgsrpvsZQvebg3rmKZ/gzh+APXovu9C62MqOS
        eMUO+KDMGqzAjYQt7FVn8db+iE0fBsjMuTZHyKJ5zA2/aygYwnbVARA4xYQpTsShBBbfYc
        YIzxFXTT/xyUIsAJZRz6d6GPqD0cizI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-N6IImtt5NnOuEsoP_Qjmgw-1; Wed, 22 Apr 2020 03:59:36 -0400
X-MC-Unique: N6IImtt5NnOuEsoP_Qjmgw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30D54107ACC4;
        Wed, 22 Apr 2020 07:59:35 +0000 (UTC)
Received: from gondolin (ovpn-112-195.ams2.redhat.com [10.36.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C4F21001902;
        Wed, 22 Apr 2020 07:59:30 +0000 (UTC)
Date:   Wed, 22 Apr 2020 09:59:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 03/10] s390x: cr0: adding AFP-register
 control bit
Message-ID: <20200422095928.0623886c.cohuck@redhat.com>
In-Reply-To: <1582200043-21760-4-git-send-email-pmorel@linux.ibm.com>
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
        <1582200043-21760-4-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Feb 2020 13:00:36 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> While adding the definition for the AFP-Register control bit, move all
> existing definitions for CR0 out of the C zone to the assmbler zone to
> keep the definitions concerning CR0 together.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 11 ++++++-----
>  s390x/cstart64.S         |  2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

