Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D89C537940
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiE3Knb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 06:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiE3Kn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 06:43:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195967092E;
        Mon, 30 May 2022 03:43:25 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9Xubs013204;
        Mon, 30 May 2022 10:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=djv0+l8cdCMs2AXk4dJ8GHFW/CWC71QuRmanB9cAsqg=;
 b=CAWbxK5VNQlr4OUhaD5+wMj6uZCjRTNXtw8tF/JJE+c2epFaxKbY4HzLGiz3tWUx9iX3
 mq639SB+Cvpzbd9uUhjltXVadIENU0r7wIJI1vPcwk4BCLb5MVGWsv7g/uH3r1JyPR6H
 WS11YT5YS2PyqdZAmfq0TvkYupfVzTsyXjAeR7TwDULZILOCI2MuuhRphQzTtb0/nx74
 SSzzXUjlXc8auRZr1Zc9sKiL5T39IYBCBrlJkvK3eJ650WGMrVy/b2QroQsoxckMP3jb
 HuBQnnz+5JpcinBODUrmbG+5wNx8SlwTO9pUT2JP+Jmc0wR3ppKT8hK/JoounInG7Kpp ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudgh74y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:43:24 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UAhNJ1008729;
        Mon, 30 May 2022 10:43:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudgh74k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:43:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UAWuLN030403;
        Mon, 30 May 2022 10:43:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynjkc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:43:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UAhInr44433788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 10:43:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E552A405B;
        Mon, 30 May 2022 10:43:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04788A405C;
        Mon, 30 May 2022 10:43:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 10:43:17 +0000 (GMT)
Date:   Mon, 30 May 2022 12:43:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 14/19] KVM: s390: pv: cleanup leftover protected VMs
 if needed
Message-ID: <20220530124315.31dc3742@p-imbrenda>
In-Reply-To: <ff5f394db586169fe6dc16dc0e24d534e4825caa.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-15-imbrenda@linux.ibm.com>
        <ff5f394db586169fe6dc16dc0e24d534e4825caa.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oHh5hNQ89EDiVKZ149snJANkX2vEhK2N
X-Proofpoint-ORIG-GUID: aL4QO2Clu9DBGL2q9Rswrbb_9gR3oo80
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 10:11:37 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> [...]
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index bd850be08c86..b20f2cbd43d9 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -17,6 +17,19 @@  
> [...]
> > +/**
> > + * @struct deferred_priv
> > + * Represents a "leftover" protected VM that is still registered
> > with the
> > + * Ultravisor, but which does not correspond any longer to an active
> > KVM VM.
> > + */
> > +struct deferred_priv {  
> 
> Why not just name this leftover_vm?

because I did not think of it :)

will fix
