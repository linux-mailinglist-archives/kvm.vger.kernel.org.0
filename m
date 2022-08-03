Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF45887DD
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 09:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiHCHWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 03:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiHCHWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 03:22:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3711CFF8;
        Wed,  3 Aug 2022 00:22:10 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27362OBm012206;
        Wed, 3 Aug 2022 07:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=7EHvYAmYBgXM4ChV81QhWz3DuYlCMSJBxhnz4hgFkzI=;
 b=SuOa+66eeq9Be2EYLPBx/EalPCvhv78GmIjTc+Q5+erPawIVxIocubG1zGSNnVj1BDHs
 cEMkO7aXZ+lYyPc9V29Zow4AxQBD6InhvDN39iI1BOoXaCMxTU7H4vN3dEgADRrNUNU9
 bO5EM7Tk1NY5XfmnmYuy2w53pI3+CuYOa8uMBzypMbkETJBr3AISGyDZWNqD7hCAXyY4
 IaMOYGzpfUAUs3M+Vt85ZrsuIsGxd1GdRD5jH+TxkI2/DQ60ve6IGSu6XoSKqRXlcihA
 Zo4MCUG21lVQ6Edr5KTnnw2zzELP7KwKiHd4Fgyu+OIk641gQyUOyLKmpF1qIrUUkah9 sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqkdbadtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 07:22:09 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273643Q9018185;
        Wed, 3 Aug 2022 07:22:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqkdbadt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 07:22:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2737LwTj015057;
        Wed, 3 Aug 2022 07:22:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3hmv98vf30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 07:22:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2737JmFs30540048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 07:19:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7183AE04D;
        Wed,  3 Aug 2022 07:22:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B450AE045;
        Wed,  3 Aug 2022 07:22:03 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.22.238])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 07:22:03 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220725130859.48740-1-frankja@linux.ibm.com>
References: <20220707111912.51ecc0f2@p-imbrenda> <20220725130859.48740-1-frankja@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        thuth@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3] s390x: uv-host: Add access checks for donated memory
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165951132332.11298.683533858623578126@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Wed, 03 Aug 2022 09:22:03 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CyHXtYb1tpjNpZwHfARpAH80-yjlNelg
X-Proofpoint-ORIG-GUID: 6Pcm3AJLku9X_bmJNZ6ypQ-JLC_2Wakh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=948
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208030032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-25 15:08:59)
> Let's check if the UV really protected all the memory we donated.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
