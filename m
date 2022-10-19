Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE42B604CC7
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJSQI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJSQIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:08:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7E713333E
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:08:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFiFoN004126
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kopqt5nnArU1fNDUCrEph7csOGBVD/QfhuPanB51eo0=;
 b=XZI1tTWqRfaOz/FVb3xbMvexNo9xNtR2SF2PPFebTAdS3jX0ZalE5zo/BJcEouKScFoo
 ye0mxSxe0Ducc9Rfau6+RhDiMgaHgXtv1ADHkg3lQRL+0Vde0FfM/IaFlv27t7EqhEr+
 +rRVSWcywIrkje1o7JSF5uKGpY9adVxGBc5jwhGqVSmJ1y8QtOmRg/MqcXO1jhyLQwVo
 ozJNtH6whQ2o0QMBKAEKoDvyCAkuEtm2yHkHQ/m3F6QIZod+YVD4Og8oqF2l+xb9/oL7
 l9r2OPfn1kCv+UyMAQBofjENvoWy4vUBIDnEoSFujqJj8LmMkShtnhMHr7fyRV0Zx0OW rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kam4u0vq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:08:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFj8xH006888
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:08:50 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kam4u0vnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:08:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JFqNLg004255;
        Wed, 19 Oct 2022 16:03:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kajmrr5f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:03:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFwiqs30671304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:58:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D61C54C04A;
        Wed, 19 Oct 2022 16:03:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 948EE4C040;
        Wed, 19 Oct 2022 16:03:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 16:03:44 +0000 (GMT)
Date:   Wed, 19 Oct 2022 18:03:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump
 support by default
Message-ID: <20221019180342.2d8b7ca1@p-imbrenda>
In-Reply-To: <166619305695.37435.2798515077166987872@t14-nrb>
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
        <20221019171920.455451ea@p-imbrenda>
        <166619305695.37435.2798515077166987872@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gNckSS0GQz3M0sSA9lxro-PRHRdoTOp8
X-Proofpoint-ORIG-GUID: tYfGTl5BZG3FXYmmckAEf5Zk2xZ7b61f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 17:24:16 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-10-19 17:19:43)
> > On Wed, 19 Oct 2022 16:53:19 +0200
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >   
> > > v1->v2:
> > > ---
> > > * add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
> > > * add comment (thanks Janosch)
> > > 
> > > Currently, dump support is always enabled by setting the respective
> > > plaintext control flag (PCF). Unfortunately, older machines without
> > > support for PV dump will not start the guest when this PCF is set.  
> > 
> > maybe for the long term we could try to fix the stub generated by
> > genprotimg to check the plaintext flags and the available features and
> > refuse to try to start if the required features are missing.
> > 
> > ideally providing a custom message when generating the image, to be
> > shown if the required features are missing. e.g. for kvm unit test, the
> > custom message could be something like
> > SKIP: $TEST_NAME: Missing hardware features
> > 
> > once that is in place, we could revert this patch  
> 
> But that would mean that on machines which don't support dumping, PV tests will never run, will they?

no, the check would be done at run time, so the test would only be
skipped on machines that don't support dumping (or whatever other
feature)

but again, this is a long term idea, for now we'll take your patch
since it solves the problem :)

> 
> So we need some way of specifing at compile time whether you want dump support or not.

