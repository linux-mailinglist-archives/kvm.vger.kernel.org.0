Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E704E5F98
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 08:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348701AbiCXHlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 03:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbiCXHlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 03:41:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020595E766;
        Thu, 24 Mar 2022 00:39:36 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22O4pbBm012974;
        Thu, 24 Mar 2022 07:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=mRbbFnGWvVlAn/PvdhUWT6XytJ4Hr9/ADHu1SFl1VSQ=;
 b=tVktvGISMrevWHOz/kqKSChzO5Vl4mwVouI+amh9oLDQ4M0Eu6oMUXhQvowVLpYAxMFs
 MFuzkDM7Kg9K59o2lKKzZpNpLa1MOSiCb6jcOSaxvFEscYUVrfkgAWn89m6zcfkdmWCT
 OPk86LsCKTZ8gAXmzNx5TQ2aW0eJBYRyQHN5fbT868O//IxKIqWMkHS1PAiBi7z6byp9
 rcW/Ka037mq5l9qT7Gl/n2h2wzHiCyp21ZHycMnQ6eDFluxNyTLUSzCBC8aER6kF1+J8
 yxYAf8bZAEJrZo0jgU8T3o30pqY6u0ErSqzUlCHvNIrnzjuvVGT3CuF3Zgbq0ImRVIEb Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0j03jn5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 07:39:35 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22O7IYox001637;
        Thu, 24 Mar 2022 07:39:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0j03jn56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 07:39:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22O7btvi014350;
        Thu, 24 Mar 2022 07:39:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ew6t9gste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 07:39:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22O7dUbL38994424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 07:39:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F377A4051;
        Thu, 24 Mar 2022 07:39:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E7FDA4040;
        Thu, 24 Mar 2022 07:39:30 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.8.199])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Mar 2022 07:39:30 +0000 (GMT)
Message-ID: <7a624f37d23d8095e56a6ecc6b872b8b933b58bb.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Thu, 24 Mar 2022 08:39:29 +0100
In-Reply-To: <20220323184512.192f878b@p-imbrenda>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
         <20220323170325.220848-5-nrb@linux.ibm.com>
         <20220323184512.192f878b@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2g8h1qB_cMnbq9pXqEz2t8lzY0zY8FOi
X-Proofpoint-GUID: mrSRVshWkUp1Ukd9iRNC9Trdylqfa73p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_08,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203240043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-23 at 18:45 +0100, Claudio Imbrenda wrote:
> On Wed, 23 Mar 2022 18:03:20 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
[...]
> > +
> > +static int memisset(void *s, int c, size_t n)
> 
> function should return bool..

Sure, changed.

[...]
> > +static void test_store_adtl_status(void)
> > +{
> > 
[...]
> > +
> > +       report_prefix_push("unaligned");
> > +       smp_cpu_stop(1);
> > +
> > +       cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> > +                 (unsigned long)&adtl_status + 256, &status);
> > +       report(cc == 1, "CC = 1");
> > +       report(status == SIGP_STATUS_INVALID_PARAMETER, "status =
> > INVALID_PARAMETER");
> 
> and check again that nothing has been written to

Oh, thanks. Fixed.

[...]
> > +static void test_store_adtl_status_unavail(void)
> > +{
> > +       uint32_t status = 0;
> > +       int cc;
> > +
> > +       report_prefix_push("store additional status unvailable");
> > +
> > +       if (have_adtl_status()) {
> > +               report_skip("guarded-storage or vector facility
> > installed");
> > +               goto out;
> > +       }
> > +
> > +       report_prefix_push("not accepted");
> > +       smp_cpu_stop(1);
> > +
> > +       cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
> > +                 (unsigned long)&adtl_status, &status);
> > +
> > +       report(cc == 1, "CC = 1");
> > +       report(status == SIGP_STATUS_INVALID_ORDER,
> > +              "status = INVALID_ORDER");
> > +
> 
> I would still check that nothing is written even when the order is
> rejected

Won't hurt, added.

[...]
> > +static void restart_write_vector(void)
> > +{
> > +       uint8_t *vec_reg;
> > +       /*
> > +        * vlm handles at most 16 registers at a time
> > +        */
> 
> this comment can /* go on a single line */

OK

[...]
> > +               /*
> > +                * i+1 to avoid zero content
> > +                */
> 
> same /* here */

OK, changed.

[...]
> > +static void __store_adtl_status_vector_lc(unsigned long lc)
> > +{
> > +       uint32_t status = -1;
> > +       struct psw psw;
> > +       int cc;
> > +
> > +       report_prefix_pushf("LC %lu", lc);
> > +
> > +       if (!test_facility(133) && lc) {
> > +               report_skip("not supported, no guarded-storage
> > facility");
> > +               goto out;
> > +       }
> 
> I think this ^ should not be there at all

It must be. If we don't have guarded-storage only LC 0 is allowed:

"When the guarded-storage facility is not installed, the
length and alignment of the MCESA is 1024 bytes.
When the guarded-storage facility is installed, the
length characteristic (LC) in bits 60-63 of the
MCESAD specifies the length and alignment of the
MCESA as a power of two"

See below for the reason why we don't have gs here.

[...]
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 1600e714c8b9..843fd323bce9 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -74,9 +74,29 @@ extra_params=-device diag288,id=watchdog0 --
> > watchdog-action inject-nmi
> >  file = stsi.elf
> >  extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-
> > 0242ac130003 -smp 1,maxcpus=8
> >  
> > -[smp]
> > +[smp-kvm]
> >  file = smp.elf
> >  smp = 2
> > +accel = kvm
> > +extra_params = -cpu host,gs=on,vx=on
> > +
> > +[smp-no-vec-no-gs-kvm]
> > +file = smp.elf
> > +smp = 2
> > +accel = kvm
> > +extra_params = -cpu host,gs=off,vx=off
> > +
> > +[smp-tcg]
> > +file = smp.elf
> > +smp = 2
> > +accel = tcg
> > +extra_params = -cpu qemu,vx=on
> 
> why not gs=on as well?

I am not an expert in QEMU CPU model, but it seems to me TCG doesn't
support it.

