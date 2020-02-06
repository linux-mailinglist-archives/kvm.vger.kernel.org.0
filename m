Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C064154840
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBFPl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:41:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbgBFPl0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 10:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581003685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9wMwSq0HYfGlp3ThYr5DJrLa20xKFoqvuSdrLGy9yV8=;
        b=TW8xZMRSIYGEsmzzAPj2tTNZCkgDIabOyvL9wQtm3ySKZjMcI+wB95I7VoH6f8n5xpCBVV
        hFk5e5JvNYvLHE8lhBz6NsMM2i+fU2DAym2c2bmW1W2+aNJr8LC8DODysLQj4o7C38FckK
        tY4eJmcL5BxYzbtjlTkJko/DjhmMbnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-8JnXo92QOgiTftGzzdRklw-1; Thu, 06 Feb 2020 10:41:20 -0500
X-MC-Unique: 8JnXo92QOgiTftGzzdRklw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 648AE102CE16;
        Thu,  6 Feb 2020 15:41:19 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CB555DA7C;
        Thu,  6 Feb 2020 15:41:17 +0000 (UTC)
Date:   Thu, 6 Feb 2020 16:41:15 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 05/27] docs: virt: convert halt-polling.txt to ReST
 format
Message-ID: <20200206164115.7b395348.cohuck@redhat.com>
In-Reply-To: <6af4ab0b9c9977b6de9abe0a120ef0904a631a52.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <6af4ab0b9c9977b6de9abe0a120ef0904a631a52.1581000481.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 15:50:02 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Fix document title to match ReST format
> - Convert the table to be properly recognized
> - Some indentation fixes to match ReST syntax.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  .../{halt-polling.txt => halt-polling.rst}    | 86 ++++++++++---------
>  Documentation/virt/kvm/index.rst              |  1 +
>  2 files changed, 46 insertions(+), 41 deletions(-)
>  rename Documentation/virt/kvm/{halt-polling.txt => halt-polling.rst} (64%)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

