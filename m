Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2473716C229
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgBYNXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:23:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54182 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729566AbgBYNXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582636986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3POW5lhsyQbNjJrPA+KwzKETLcyXtFryETy5EREowTY=;
        b=CcfT1KxfMNvhLn7imInWpnImwJkyh9uxkCrDquY47SIl0GfyREuJLybbAR/EpMVgarfVdG
        PCJKVX6YjmzUu2H000lutaMBf5/JMic3rSJzhQGJwYp2Ah3N7tGXi+8kjYAZ3+G2MW5bC+
        a2Ol10Xw900u1pCmECxvI7AHf1XVimI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-1bLL6T9kOcS8jbiDuPpAag-1; Tue, 25 Feb 2020 08:23:02 -0500
X-MC-Unique: 1bLL6T9kOcS8jbiDuPpAag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1A2108C1E4;
        Tue, 25 Feb 2020 13:23:01 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C736B91840;
        Tue, 25 Feb 2020 13:22:56 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:22:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 35/36] KVM: s390: protvirt: introduce and enable
 KVM_CAP_S390_PROTECTED
Message-ID: <20200225142254.7886a535.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-36-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-36-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:41:06 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Now that everything is in place, we can announce the feature.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 4 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

