Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0385878D7
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbiHBIR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 04:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiHBIR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 04:17:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521AB19285
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 01:17:26 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2728Dhc8015748
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 08:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=HoCaPLzItMNVKHbnJ0/3Fwrm8BsAjpytYUYeHTKo6GE=;
 b=KAf2551M2etR/sgbX8duNxNOM+vvoVjjwKjj/20sx8L1k4V1I7G+4D6q9+5JrTd4z7h3
 guXSlUyXUTuUoX8TyM46mUTN0JeIFF9fnzlwoYQ7KzU2eiu8eyzCnhGUltdaRIRJx+iD
 5IqurqGdj2Iwu0n+UQPYQ1ezbq4k/C+EhBAbYTRQGeB3K07NmlKPsrJfl0vG7apkZIu/
 lsKppr6S32g0soxDgRgTpCEaISxRHZz9DpYdFbhhfDTvGy4gAwNjHAXC6pGGudj/y4eI
 yizgnA44wIlEEWO6OjRDPFmc32Y6QMy0uNDRxMnX8NRCWUK7xsVmqW/jeG2XNTg3VIGa LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq07sr51m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 08:17:25 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2728Dou8016283
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 08:17:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hq07sr4xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 08:17:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27287pds014358;
        Tue, 2 Aug 2022 08:17:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98ke32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 08:17:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2728GwJF27066826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 08:16:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C93DF11C052;
        Tue,  2 Aug 2022 08:16:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADEE911C04C;
        Tue,  2 Aug 2022 08:16:58 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 08:16:58 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-7-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-7-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] lib: s390x: sie: Properly populate SCA
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942821849.253051.4844800369210383799@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 10:16:58 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YjO1A99swQ250GeQjbtPYMkbalHsX7kE
X-Proofpoint-GUID: LdvPa8hPXf_2-5Tc9qApczhI6od63w_f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=786 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:33)
> CPU0 is the only cpu that's being used but we should still mark it as
> online and set the SDA in the SCA.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
