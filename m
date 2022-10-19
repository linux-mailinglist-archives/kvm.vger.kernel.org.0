Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502F4604F30
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJSR5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 13:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJSR5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 13:57:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75441CC3F6
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 10:57:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGC7NS014876;
        Wed, 19 Oct 2022 17:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=/xMreriU+31uXvWJjV2YSNJJwQFg+4U2/9ARamyXzUM=;
 b=FcmSdTL8pe0Yz4OTtjGwjWaSiJIFZ4ude3bmvfyxue4nmH7ou1SSUIactEHifbzBJCT6
 x9weXJWpAvLwM9eFWLGyvGxgK9s7b4Y5y7yCTylvyy4YcMMGqVjsUymtkoyXP7c+Lok6
 TIjPezesUmKn5oDD5t1rN1iEEoMcDW28koT3V3+hVr5cGmnW3Y8u+Vwi+kAcBqtNTF8h
 bKotgsmvA+VqAGrVhi+Emv31TkZHcPDAey2UI9X31jNALRjLwU2uQu4fiZaZJd2tL3L/
 tN0NGTSM81SIfxWORDY0cqYaqea6GiDfeQ6qtObItO4ibWhUovRYYQvTbCA3DfYg7niF Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kamhx36f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:56:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JH2XDu016750;
        Wed, 19 Oct 2022 17:56:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kamhx36ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:56:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JHuheB001044;
        Wed, 19 Oct 2022 17:56:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3k7mg95p2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 17:56:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JHvDE852363674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 17:57:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78BA142041;
        Wed, 19 Oct 2022 17:56:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A376B4203F;
        Wed, 19 Oct 2022 17:56:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.16.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 17:56:39 +0000 (GMT)
Message-ID: <f3b7dc0cbbbcb53f9763a0ed00f96e8157002517.camel@linux.ibm.com>
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
Date:   Wed, 19 Oct 2022 19:56:39 +0200
In-Reply-To: <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-2-pmorel@linux.ibm.com>
         <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
         <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZmEJoVBUOCGmKItUSyQXBfyBloswc0PL
X-Proofpoint-GUID: 9aLup1NQoCP_iTB_xpZUWWH3rXCFYKa7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_11,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=763 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-10-19 at 17:39 +0200, Pierre Morel wrote:
> 
> On 10/18/22 18:43, Cédric Le Goater wrote:
[...]
> > 
> > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > new file mode 100644
> > > index 0000000000..42b22a1831
> > > --- /dev/null
> > > +++ b/hw/s390x/cpu-topology.c
> > > @@ -0,0 +1,132 @@
> > > +/*
> > > + * CPU Topology
> > > + *
> > > + * Copyright IBM Corp. 2022
> > 
> > The Copyright tag is different in the .h file.
> 
> OK, I change this to be like in the header file it seems to be the most 
> used format.
> 
No, this form, with the date at the end, is the correct one.
> 

[...]
