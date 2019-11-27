Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47BB10AF02
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 12:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfK0Lvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 06:51:44 -0500
Received: from mx.notenbomer.nl ([77.74.49.8]:41974 "EHLO
        zimbra01.gemeenteoplossingen.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfK0Lvo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 06:51:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra01.gemeenteoplossingen.nl (Postfix) with ESMTP id E13B4140C05B
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 12:51:41 +0100 (CET)
Received: from zimbra01.gemeenteoplossingen.nl ([127.0.0.1])
        by localhost (zimbra01.gemeenteoplossingen.nl [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id LnoDR32d4RTx for <kvm@vger.kernel.org>;
        Wed, 27 Nov 2019 12:51:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra01.gemeenteoplossingen.nl (Postfix) with ESMTP id 98D02140C05C
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 12:51:41 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra01.gemeenteoplossingen.nl 98D02140C05C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gemeenteoplossingen.nl; s=2DADCD3C-B4AA-11E7-9A56-71D228D99426;
        t=1574855501; bh=pkRRG4Jr+mVeaB/7OVlqfTPsvs71J18NLlGmIxF6iaY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=cWmGQIdetazLRYwv50w2N2JSAhc5RRqlVJ560Awn8lhdXA3aq7rqoNDTN9rJpoBEF
         8QF98++66hhVdxPlBPMcoyBxrUBJ7oiedFaMFnucI9xVRD7OWHkEQ4zWzghryX0Nlt
         wCEHYnUe2kSyAyCSTK8jXvxtvTrqC6UzCE8b5LY4dC6HHtShFZlYTFY63bdOTdhkfN
         YH/Nv0Y68gDnmGoqgQhZNF5098CTsxerPdJjuRscT0GNATYTfwTNjhhAmfHTH8ggec
         c+GrTzbukH3VPto6mPEXon/Tzz7J+KjRJVl4SWJOXOsJNhfQ6F80JUGMcvzailpSmP
         HBq/9RMrmbsIA==
X-Virus-Scanned: amavisd-new at zimbra01.gemeenteoplossingen.nl
Received: from zimbra01.gemeenteoplossingen.nl ([127.0.0.1])
        by localhost (zimbra01.gemeenteoplossingen.nl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ItN1eYOkFigq for <kvm@vger.kernel.org>;
        Wed, 27 Nov 2019 12:51:41 +0100 (CET)
Received: from zimbra01.gemeenteoplossingen.nl (zimbra01.gemeenteoplossingen.nl [77.74.49.8])
        by zimbra01.gemeenteoplossingen.nl (Postfix) with ESMTP id 787DE140C04C
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 12:51:41 +0100 (CET)
Date:   Wed, 27 Nov 2019 12:51:41 +0100 (CET)
From:   Gradus Kooistra <gradus@gemeenteoplossingen.nl>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <1778214032.3890788.1574855501447.JavaMail.zimbra@gemeenteoplossingen.nl>
Subject: Guest system gets random high io-waittime. Restart virtual machine
 resolves the issue
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - GC78 (Win)/8.8.10_GA_3786)
Thread-Index: xPfN5BcXUNUJ1/ag9MFU5TgzSZTQGA==
Thread-Topic: Guest system gets random high io-waittime. Restart virtual machine resolves the issue
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,


We are running KVM on Ubuntu (16.04). Sometimes a guest machine is getting =
a very high IO-Wait time, but there is not that much of disk-activity neede=
d.
Restarting the KVM solves the problem. At the same time, the other guests d=
os not have the problem, running on the same machine (so it is just that on=
e virtual machine).


We got this issue now for almost two years.

What is the best place of make a report of this issue?


Met vriendelijke groet,=20
Gradus Kooistra=20


De inhoud van dit bericht is vertrouwelijk. Als dit niet voor u bestemd is,=
 wordt u vriendelijk verzocht dit bericht en eventuele kopie=C3=ABn daarvan=
 vertrouwelijk te behandelen en te vernietigen en dit aan de afzender te me=
lden.
