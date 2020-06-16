Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FBB1FAC6E
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgFPJb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:31:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54573 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgFPJb4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 05:31:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592299916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=F20CRMfoO8bHlYTAqdN2hpd5nJ84jpOHdv9uy+0x/Gs=;
        b=PtoA08q3NAJkEWcq2ctexFSjsxE4nAYZ8x0hfMZ3Y54DvjSJlpBrWqW5WwIbZlrBJ/3GEZ
        /yG/QLacTCJl+YQ9J0vTVh/JlIfzFyFdBkhz0ChyLJGOklnCzam/xhU6deR58M3k+bevS0
        TqyQ2OXMlzBQYH1lE3ZUCI3BZuAjhEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-PrRlZxwgP6qyWtu-NFfMbw-1; Tue, 16 Jun 2020 05:31:53 -0400
X-MC-Unique: PrRlZxwgP6qyWtu-NFfMbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7231803315;
        Tue, 16 Jun 2020 09:31:52 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3E63108C4;
        Tue, 16 Jun 2020 09:31:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 01/12] s390x: Use PSW bits definitions
 in cstart
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <accfc1b6-6ddb-2b04-7f8a-ea6fd83b8b2f@redhat.com>
Date:   Tue, 16 Jun 2020 11:31:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.31, Pierre Morel wrote:
> This patch defines the PSW bits EA/BA used to initialize the PSW masks
> for exceptions.
> 
> Since some PSW mask definitions exist already in arch_def.h we add these
> definitions there.
> We move all PSW definitions together and protect assembler code against
> C syntax.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 15 +++++++++++----
>  s390x/cstart64.S         | 15 ++++++++-------
>  2 files changed, 19 insertions(+), 11 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

