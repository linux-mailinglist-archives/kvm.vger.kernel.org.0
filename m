Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B646D4B6AA0
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbiBOLYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:24:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiBOLYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:24:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED671081AB
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:23:51 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FA1r9R012926
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+nH6SOvNIkB9XHCbTawySKW/FWCjn66dUu01mE13fEI=;
 b=D7eNdqYSZDWRGJf2wPGQ2LsG3BO4Nc5VsNYXqGdK4j1VThWZ4p3/25Wi0uUd+cXYbVP6
 Iy7rPD2reMHccuWfledqOx9Fx6jJIHvMSAvbv6ZivcviH0LOrO6c3SU7UBtVSpUeKyvs
 5jPOC5nsjQvvwdpPeANHZaqBPO3TuUzqiCrE9Dv27R5622592RrL2KU/r+la1py/TweS
 zvXeFaGHsbdjHQHediARCREV286Y5oZn1bJj/LhDHxFmsXGmcIqS63LSPDBm/oyHMM+6
 RfgDUhVYkd/OwYYkUF9U/dEFuQXbIsi5wntO0hvE2lPV1MRf9RQ5wM2de06+wOEqiDUm 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e85fs0arw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:23:50 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FAUQ6I030972
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:23:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e85fs0arh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:23:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBBxND025186;
        Tue, 15 Feb 2022 11:23:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3e64h9w7ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:23:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBNj8g48365970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:23:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 204D052054;
        Tue, 15 Feb 2022 11:23:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BA1D55204F;
        Tue, 15 Feb 2022 11:23:44 +0000 (GMT)
Date:   Tue, 15 Feb 2022 12:23:42 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/6] lib: s390x: smp: refactor smp
 functions to accept indexes
Message-ID: <20220215122342.62efd8b8@p-imbrenda>
In-Reply-To: <698c33f2-7549-3420-ce97-d15c86b4dc02@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
        <20220204130855.39520-3-imbrenda@linux.ibm.com>
        <698c33f2-7549-3420-ce97-d15c86b4dc02@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jmZpzfB61O4oXsOheCNFhJ0Dfob67VLB
X-Proofpoint-GUID: dmSbxjCHUevkMLmHK7aZXqqKKgguUmxP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=984 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Feb 2022 12:09:53 +0100
Steffen Eiden <seiden@linux.ibm.com> wrote:

[...]

> What about using the smp wrapper 'smp_sigp(idx, SIGP_RESTART, 0, NULL)' 
> here as well?

[...]

> With my nits fixed:

maybe I should add a comment explaining why I did not use the smp_
variants.

the reason is that the smp_ variants check the validity of the CPU
index. but in those places, we have already checked (directly or
indirectly) that the index is valid, so I save one useless check.

on the other hand, I don't know if it makes sense to optimize for that,
since it's not a hot path, and one extra check will not kill the
performance.

> 
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

