Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156343B04B4
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVMka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 08:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230304AbhFVMk3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 08:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624365493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQ5KcZC59TY8SJE6+LeVJN/R0Q432ZJ1qyJqA5bq+2k=;
        b=eF6UNyjtI9paCOuxJlaUueYQNeohx5LUqxnMQIfiiNd5gjYOvMyMWFdaZwHSaNtCXAajeX
        jCrR/pfGnan13NZ7xWCAH7KUnzP/1grVWYSi82nUlYSLIXohBa/AMOB/IdYokg/TDBh9t9
        gKgV+59qmkzwhO/xNEZttU0k1rRmCGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-5Dncq8bLOhW8Yn3gwg5blQ-1; Tue, 22 Jun 2021 08:38:11 -0400
X-MC-Unique: 5Dncq8bLOhW8Yn3gwg5blQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADBC510C1ADC;
        Tue, 22 Jun 2021 12:38:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BC245D740;
        Tue, 22 Jun 2021 12:38:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org, Lara Lazier <laramglazier@gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests] svm: Updated cr4 in test_efer to fix report msg
Date:   Tue, 22 Jun 2021 08:38:09 -0400
Message-Id: <162436548630.1387632.13796295738140792225.b4-ty@redhat.com>
In-Reply-To: <20210621153925.31375-1-laramglazier@gmail.com>
References: <20210621153925.31375-1-laramglazier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Jun 2021 17:39:25 +0200, Lara Lazier wrote:
> Updated cr4 so that cr4 and vmcb->save.cr4 are the same
> and the report statement prints out the correct cr4.
> 
> v1->v2: moved the assignment to vmcb->save.cr4 back to the previous test
> as described in the comment.

Applied, thanks!

[1/1] svm: Updated cr4 in test_efer to fix report msg
      commit: fc050452b8c37729c2348e7c63075cc2a9ae3738

Best regards,
-- 
Paolo Bonzini <pbonzini@redhat.com>

