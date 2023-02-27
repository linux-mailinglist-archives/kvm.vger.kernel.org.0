Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427A26A4626
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjB0PfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjB0PfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4D1F965
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 07:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677512075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pf57iGYw7tc5yWrllmnQ1KbHMXZrJwdvHRaL6K/RmqM=;
        b=KmTk+yxp5Iflq9Q1P7h7JnTAyXRWiszM2fon8xWXGzH3jP2iwuFTAhF6TUflI8RyUvwArr
        lzVW0iLCyYxkwoRiiBwCEmdOkxnn3EI5QGIhZvVR4aDoD0EWeoZKoJH6JkirMrNmLud7nU
        1I3cDt6Gj72ECNVpqbeLUO/ZbW7gx+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-I015Qc6ONw2s2eSUN08pUw-1; Mon, 27 Feb 2023 10:34:32 -0500
X-MC-Unique: I015Qc6ONw2s2eSUN08pUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDD8A1C068C8;
        Mon, 27 Feb 2023 15:34:31 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2DF4140EBF4;
        Mon, 27 Feb 2023 15:34:31 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 94A2521E6A1F; Mon, 27 Feb 2023 16:34:23 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
        <20230222142105.84700-9-pmorel@linux.ibm.com>
        <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
        <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
        <9e1cbbe11ac1429335c288e817a21f19f8f4af87.camel@linux.ibm.com>
        <87v8jnqorg.fsf@pond.sub.org>
        <d8da6f7d1e3addcb63614f548ed77ac1b8895e63.camel@linux.ibm.com>
Date:   Mon, 27 Feb 2023 16:34:23 +0100
In-Reply-To: <d8da6f7d1e3addcb63614f548ed77ac1b8895e63.camel@linux.ibm.com>
        (Nina Schoetterl-Glausch's message of "Mon, 27 Feb 2023 13:51:19
        +0100")
Message-ID: <871qmbqg00.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:

> CpuS390Entitlement would be useful in both machine.json and machine-target.json
> because query-cpu-fast is defined in machine.json and set-cpu-topology is defined
> in machine-target.json.
> So then the question is where best to define CpuS390Entitlement.
> In machine.json and include machine.json in machine-target.json?
> Or define it in another file and include it from both?

Either should work.

If you include machine.json into machine-target.json, the
qapi-FOO-machine-target.h will include the qapi-FOO-machine.h.  No big
deal, I think: affects just eight .c.

