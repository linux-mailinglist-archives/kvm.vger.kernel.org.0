Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAF939379B
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 22:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhE0U5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 16:57:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhE0U5U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 16:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622148946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ni+6hZkXSLJW6jwPDxlTzbnxmvvtFCkE6EjrUKSV94=;
        b=VGsD/lt/qxQw5+PyuVYfbCCytXQdE145c3LsJPG1RtSVEPoE0KPb1OslDkfBNgXLmOBriW
        ETavVrybfY2fpvVbx+GfDjZtYykr8pKbf/Viirxu8lyTkrD6GjFx5c6sIu04O4I+bmjre4
        d8Lw0x8l9tI+9TfSKfxWSLKNiP1xY5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-1JOpoCinNia1tgIZzHnFqA-1; Thu, 27 May 2021 16:55:44 -0400
X-MC-Unique: 1JOpoCinNia1tgIZzHnFqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E237100AA27;
        Thu, 27 May 2021 20:55:39 +0000 (UTC)
Received: from localhost (ovpn-117-209.rdu2.redhat.com [10.10.117.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A39C5189C7;
        Thu, 27 May 2021 20:55:38 +0000 (UTC)
Date:   Thu, 27 May 2021 16:55:37 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, armbru@redhat.com, dgilbert@redhat.com,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] target/i386/sev: add support to query the attestation
 report
Message-ID: <20210527205537.nesslxq4hcnrlo7w@habkost.net>
References: <20210429170728.24322-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210429170728.24322-1-brijesh.singh@amd.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 12:07:28PM -0500, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest
> is running.
> 
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: James Bottomley <jejb@linux.ibm.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Queued, thanks!

-- 
Eduardo

