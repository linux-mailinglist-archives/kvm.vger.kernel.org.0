Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8192154C546
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347318AbiFOJ7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 05:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347312AbiFOJ7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 05:59:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511AA3B023;
        Wed, 15 Jun 2022 02:59:52 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25F8kuCU024870;
        Wed, 15 Jun 2022 09:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lBTF7emAg7+hzyjMO7wprAdMwph+OiuhuNTpiaYtriE=;
 b=CO7JMEidxvgWLDviigpCt9EaAIvePyEfq+nfW3KnCdJdufxlF+kzUHnNS0GjBMxOzj2D
 hwUc/GlmBHO20L8twoBZOt1vwdRvtxX1CcIXfpra5IAjsDltp99j8iRRdP24Mw20IV8i
 tNZF7I+1IlKo6M2DBAu7q4VtBvRo3DEEQGQwIZkirsc5brK8BuXpKPiR/SZo50dK/F9u
 1tdbCj24GZCOJnrm0+RLG9uvLaCzaNMzd4VoFaxM/OrAY049yD3FOSIaswfV3D/JEqOX
 FW8IGFdg/8NrQDBo+bUlGUyOU8WBuKcs8fG7o2vdUR2WKIYbpUOQKYNihyQRBIZR7VJ3 Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq69w0ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:51 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25F8qcED022573;
        Wed, 15 Jun 2022 09:59:51 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq69w09w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:51 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25F9odwC005639;
        Wed, 15 Jun 2022 09:59:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3gmjp8vc7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25F9xDup14745958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 09:59:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53A7D11C052;
        Wed, 15 Jun 2022 09:59:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84B9C11C050;
        Wed, 15 Jun 2022 09:59:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.67])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jun 2022 09:59:44 +0000 (GMT)
Date:   Wed, 15 Jun 2022 11:59:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v11 07/19] KVM: s390: pv: module parameter to fence
 asynchronous destroy
Message-ID: <20220615115942.762ac791@p-imbrenda>
In-Reply-To: <bcbfcc87-aef4-d151-8e34-4646f1533c25@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-8-imbrenda@linux.ibm.com>
        <bcbfcc87-aef4-d151-8e34-4646f1533c25@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0RYFp40E29VCMFLFv281UP1jSwbYr6vx
X-Proofpoint-ORIG-GUID: 4XD9-SRTwMeBqHiUaSLzNH5rEPYFe6Zj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jun 2022 11:53:17 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/3/22 08:56, Claudio Imbrenda wrote:
> > Add the module parameter "async_destroy", to allow the asynchronous
> > destroy mechanism to be switched off.  This might be useful for
> > debugging purposes.
> > 
> > The parameter is enabled by default.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>  
> 
> Normally this would be one of the last patches in the series, no?

I need the variable to be already defined, because the subsequent
patches use it to fence things

> 
> > ---
> >   arch/s390/kvm/kvm-s390.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 76ad6408cb2c..49e27b5d7c3a 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -206,6 +206,11 @@ unsigned int diag9c_forwarding_hz;
> >   module_param(diag9c_forwarding_hz, uint, 0644);
> >   MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
> >   
> > +/* allow asynchronous deinit for protected guests, enable by default */
> > +static int async_destroy = 1;
> > +module_param(async_destroy, int, 0444);
> > +MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
> > +
> >   /*
> >    * For now we handle at most 16 double words as this is what the s390 base
> >    * kernel handles and stores in the prefix page. If we ever need to go beyond  
> 

