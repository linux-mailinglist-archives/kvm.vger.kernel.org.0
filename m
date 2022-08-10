Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD93958ECD5
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiHJNNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 09:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiHJNNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 09:13:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BA2296
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 06:13:11 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AD4Fwo029695
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 13:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=06KifYW0lxdLDBFtXJUFxyibv3zjoAPkYxfWd9CXT34=;
 b=syygTKF0JvxjBNBJm+gA6/9o9nDJ7jaXi1o9Bd1KrH2vln9UCB/UsE4+4h5lAihYq1/q
 BBUzmxHsgjMlIYuzo1zJPsMrWZ/iNYWAKtZPW7N8tQ4eZU952LQ3gdKF0MR8nmDPTUZP
 wl/TOB/6LOugE1T/qZEKPE85EXtwHGfenUiCY8csakugCGInoeqlTzZKWpdJPWN2gKif
 Ck2XsqH2Rrs48JVRNQhQIrp1Vfo4exBJJf9/7vT2OBAAi68rZ878MRbS5S7x5UjHiDvN
 T7Op7ymoXpfdXieWG+jV2korY5LOTACeV2RQNm9PyDA3l38UZvY7fuUMCIbF9K2RVXCK Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vthkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 13:13:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27AD5cT2011916
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 13:13:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vthjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:13:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AD8SQO000826;
        Wed, 10 Aug 2022 13:13:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3huww2gv0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:13:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ADD4Om30802328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 13:13:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEA2A5204E;
        Wed, 10 Aug 2022 13:13:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.105])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 824825204F;
        Wed, 10 Aug 2022 13:13:04 +0000 (GMT)
Date:   Wed, 10 Aug 2022 15:13:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Message-ID: <20220810151302.67aa3d3c@p-imbrenda>
In-Reply-To: <166013456744.24812.12686537606143025741@localhost.localdomain>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-4-nrb@linux.ibm.com>
        <20220810120822.51ead12d@p-imbrenda>
        <166013456744.24812.12686537606143025741@localhost.localdomain>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7wkwIZDf_cr6cvKfGQ_J4Al5OK-zYzPr
X-Proofpoint-ORIG-GUID: yiFu-n4slBhq2SwAaMHPQBeKBxvKjSTi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_08,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=930 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Aug 2022 14:29:27 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-08-10 12:08:22)
> > > diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> > > new file mode 100644
> > > index 000000000000..d3a3f06d9a34
> > > --- /dev/null
> > > +++ b/s390x/panic-loop-extint.c  
> [...]
> > > +static void ext_int_handler(void)
> > > +{
> > > +     /*
> > > +      * return to ext_old_psw. This gives us the chance to print the return_fail
> > > +      * in case something goes wrong.
> > > +      */
> > > +     asm volatile (
> > > +             "lpswe %[ext_old_psw]\n"
> > > +             :
> > > +             : [ext_old_psw] "Q"(lowcore.ext_old_psw)
> > > +             : "memory"
> > > +     );
> > > +}  
> > 
> > why should ext_old_psw contain a good PSW? wouldn't it contain the
> > PSW at the time of the interrupt? (which in this case is the new PSW)  
> 
> That's right in case the interrupt loop occurs, it doesn't make much sense to return to ext_old_psw. But in this case lpswe will never be executed anyways.
> 
> > but this should never happen anyway, right?  
> 
> Exactly, this is just supposed to be a safety net in case the interrupt loop doesn't happen. If you want, we could remove it and just leave an empty function here. Then, we will just run into the kvm-unit-tests timeout and fail as well, but I prefer the fail fast.

just add a comment to explain that
