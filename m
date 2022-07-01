Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700EB562D7C
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 10:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiGAIK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 04:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiGAIKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 04:10:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942DF6F379
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 01:10:23 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26180XCq018308
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 08:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=67ZRHg9gXprtn/nZHoe0zO+ABW+zU3Yfve7AmvEni4U=;
 b=qYndaYi7Az7H0dJ1bMkZqK+Es7IWkSSFCgEhgHH02rpnsRgHOvxFKDdzhsiI8fEZbQG1
 t9hqmjwlScA2jJg5o3NdmfYhZ9YPLkcC8PLTaCYkazes8QmeuW4feVdppTIUGVZoiu/t
 WikYuq57SswRjTz4VoCE91YlbyfKKZH6lOzSDqEH8RfJMD3YtbEQFGpncTTxzDb7acrm
 m1Zowmnj9Fo6jHG/bqxWCjkMdqAH3cTbMyCQawlF4yihnS6NsUPX/+H8eK8+YU0tPbvm
 HMVEVIB9SER6mQSA6T9Sg1Rxf5rL4nbQyNNujhFIxYsHTp8d8OcL3miSdr8jqPMg4+1x jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1w1k8c0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 08:10:22 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26182Ime025307
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 08:10:22 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1w1k8byg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 08:10:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26186OoQ002924;
        Fri, 1 Jul 2022 08:10:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt0970tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 08:10:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2618AH3X23658928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 08:10:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C2552054;
        Fri,  1 Jul 2022 08:10:17 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.42.232])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D9A2E5204E;
        Fri,  1 Jul 2022 08:10:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <dd270d92-a5dc-8a75-0edc-e9fdbb254cc9@linux.ibm.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com> <20220630113059.229221-4-nrb@linux.ibm.com> <dd270d92-a5dc-8a75-0edc-e9fdbb254cc9@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop test
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
To:     kvm@vger.kernel.org
Message-ID: <165666301667.83789.2996985444782675194@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 01 Jul 2022 10:10:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TFVsqtyNsrFyEbtBCc6iEVshjlpySf9L
X-Proofpoint-GUID: bQyVzBp_mS4CCCQwBsvhCkpeL300d7hO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_05,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxlogscore=698
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janis Schoetterl-Glausch (2022-06-30 16:38:47)
> On 6/30/22 13:30, Nico Boehr wrote:
> > An invalid PSW causes a program interrupt. When an invalid PSW is
> > introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> > program interrupt is caused.
> >=20
> > QEMU should detect that and panick the guest, hence add a test for it.
>=20
> Why is that, after all in LPAR it would just spin, right?

The test doesn't spin for me under LPAR so it seems like LPAR can detect th=
is as well. KVM has code to detect this situation, see handle_prog() in int=
ercept.c, which then exits to userspace.

> Also, panicK.

Right, fixed.

> How do you assert that the guest doesn't spin forever, is there a timeout?

There is the default kvm-unit-tests timeout of 90 seconds, but that is prob=
ably too much for this test. I think 5 seconds should be plenty, will add.
