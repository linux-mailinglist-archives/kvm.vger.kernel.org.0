Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627915971ED
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbiHQOuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbiHQOuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBC83E749
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:50:11 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27HEGRG4033544
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=NbUsiiEyq6zvhi8pnyd0N8SUd68RuRzDtgZilbsawB4=;
 b=DtCXD68JHcz/inTycV2gW5N+9mc2Qlj4BbgPdVl2UUNhL1NYjR+N4zw8wtRNSh0WrBDe
 Fmp2YsrkKaUrKVdWlV51anNisd7wgagtZxf9aXjFuVSbbPSBMzXRFf6cK9bgg8r+HNYU
 rpUYRULbbM6FDOo3HRMMHFfqo8xo29TRJH4eRCDMHZgjmS9zgRsE9/PGfVJYGeuXuJs2
 4viQKwKKS3zoNM/iD3L6A6PjPSXh/OF9cJL5zq3oPkucet6IDGaWSRSfE9yMy8S7bBs7
 V1KS4bbJbD4xaDD2x99+zVS443wRkNcPSZnf0+gGDWmn2llgB9pY21q0OzLXWWQrMIjZ Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j11xph5ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:50:11 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27HEGeVa034374
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:50:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j11xph5b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 14:50:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27HEYNmX012425;
        Wed, 17 Aug 2022 14:50:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8vkya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 14:50:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27HEo5B533030576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 14:50:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D1434C044;
        Wed, 17 Aug 2022 14:50:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 413D64C040;
        Wed, 17 Aug 2022 14:50:05 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.25.191])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 14:50:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2ca9e34c-68c6-07c0-52cb-253a2f4a6e81@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com> <20220810074616.1223561-4-nrb@linux.ibm.com> <2ca9e34c-68c6-07c0-52cb-253a2f4a6e81@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x: smp: add tests for calls in wait state
Message-ID: <166074780500.9487.5684847888967402560@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Wed, 17 Aug 2022 16:50:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UBtxhQ7-MakvNxoeUlxHLRTPKxzYu0ow
X-Proofpoint-ORIG-GUID: oNZSL-x7Y3dHWMwSP6FVirrPV0XgsObz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_09,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=953 phishscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208170057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-08-17 09:34:46)
> On 8/10/22 09:46, Nico Boehr wrote:
> > When the SIGP interpretation facility is in use a SIGP external call to
> > a waiting CPU will result in an exit of the calling cpu. For non-pv
> > guests it's a code 56 (partial execution) exit otherwise its a code 108
> > (secure instruction notification) exit. Those exits are handled
> > differently from a normal SIGP instruction intercept that happens
> > without interpretation and hence need to be tested.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> Thanks for taking care of this work and for hunting down the kernel=20
> problems.
> Please push to devel
>=20
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks, done.
