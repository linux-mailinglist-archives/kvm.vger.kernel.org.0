Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA81F635B03
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbiKWLFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236655AbiKWLF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:05:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE4A70A25;
        Wed, 23 Nov 2022 03:04:00 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN9x7cu005812;
        Wed, 23 Nov 2022 11:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 cc : from : subject : message-id : date; s=pp1;
 bh=YKf2pahcUGgKgnS2VmdEa6c2tjWps6sv2QoSanAdv7g=;
 b=Wa8d+P8Rx7rZaGswgZCNlvUeI+V6CjGYg64kFlFHmcj/1PUuW5Axhj2sJI+Le5HB3FGz
 3fnqfIOsCempVMYaW10BXAh9fZXn/yENCsozOdltWutye5oOFC1psSHZT+4rNKXhvIWr
 Dz8aZzyeKqrgxVvupybu13dCQ3VpW90RKmK9BrU2vXcbWxRXvbm5x6z85PEujqLW1QMC
 aJl2qycsHrYyO8q2nrAS1RIP1w8zC6ZgXfNcf8AYoaLiMlFFR5FW9A11ZyEmVxIDYHtb
 VjH8Ws5H0OWdnPd8lWKVbEnxzigSOxdSyctuCgi6zyDW1wYV//eDRoKtm3cPCU1q1oOl 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0ytb33w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 11:03:59 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANAqmjb016857;
        Wed, 23 Nov 2022 11:03:58 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0ytb33vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 11:03:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANAqU9x012541;
        Wed, 23 Nov 2022 10:58:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj42ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:58:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANAxYm030474502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 10:59:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49FF6AE04D;
        Wed, 23 Nov 2022 10:58:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CB1AAE045;
        Wed, 23 Nov 2022 10:58:53 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.46.182])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 10:58:53 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221123084656.19864-3-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com> <20221123084656.19864-3-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: snippets: Fix SET_PSW_NEW_ADDR macro
Message-ID: <166920113134.14080.7996868063383584751@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 23 Nov 2022 11:58:52 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jLUsdsEyXkDlSZmmL63S7-rfY3E3g2c-
X-Proofpoint-GUID: y72zz-o59lpk-VHekdm-mF2cEkwnZCn5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=940 adultscore=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-11-23 09:46:53)
> Let's store the psw mask instead of the address of the location where we
> should load the mask from.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
