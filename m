Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC1134C6D9
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhC2IKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231802AbhC2IKD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617005399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNFofQAtkBVNBMIylJdOe3v/rllL9AmBtMuddIFkjxQ=;
        b=c2kOBjI3aL9699JguKTE8NDP3WAkWFnoPKmma7vwPz6EaP5BsJYec6linTbvSx8ff2Z1l8
        S0ZqLe4YtejIANtDBU3i6FZC8hJk1vIVluv/FWd5DwNmuBF0ScHN7F76ZrE60q2Iucj9vh
        bHXXNsIw6ag1/FTu3JooWdILI0UrLCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-mIbK1ueGOySNmzn1kAZ8kw-1; Mon, 29 Mar 2021 04:09:55 -0400
X-MC-Unique: mIbK1ueGOySNmzn1kAZ8kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A0CE180FCAC;
        Mon, 29 Mar 2021 08:09:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D96C719C45;
        Mon, 29 Mar 2021 08:09:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f2c2b1a9-d1ae-624b-7c1c-0636dcaa36c3@redhat.com>
Date:   Mon, 29 Mar 2021 10:09:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 10.39, Pierre Morel wrote:
> We need the SCSW definitions to test clear and halt subchannel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

